# encoding: UTF-8

class EventsController < ApplicationController

  # order is important here, we need to be authenticated before we can check permission
  before_filter :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource only: [:new, :show, :update, :edit, :destroy]

  respond_to :html, :js

  def index
    @events = Event.where('end_date > ?', DateTime.now).order(:name)
    if user_signed_in?
      @events += Event.accessible_by(current_ability).to_a
    end
    @events.uniq!
  end

  def show
    @registration = @event.registrations.build

    if current_user
      @registration.name = current_user.username
      @registration.student_number = current_user.cas_ugentStudentID
      @registration.email = current_user.cas_mail
    end
  end

  def new
  end

  def edit
  end

  def destroy
    @event.destroy
    redirect_to action: :index
  end

  def update
    authorize! :update, @event

    if @event.update params.require(:event).permit(:name, :club_id, :location, :website, :contact_email, :start_date, :end_date, :description, :bank_number, :registration_close_date, :registration_open_date, :show_ticket_count)
      flash.now[:success] = "Successfully updated event."
    end

    render action: :edit
  end

  def create
    authorize! :create, Event

    @event = Event.create params.require(:event).permit(:name, :club_id, :location, :website, :contact_email, :start_date, :end_date, :description)

    respond_with @event
  end

  def statistics
    @event = Event.find params.require(:id)
    authorize! :view_stats, @event
    @data = @event.access_levels.map do |al|
      {name: al.name, data: al.registrations.group('date(registrations.created_at)').count}
    end
  end

  def scan
    @event = Event.find params.require(:id)
    authorize! :update, @event
  end

  def check_in
    @event = Event.find params.require(:id)
    authorize! :update, @event
    barcode = params.require(:code)

    @registration = @event.registrations.find_by_barcode barcode

    if @registration
      if @registration.checked_in_at
        flash.now[:warning] = "Person already checked in at " + view_context.nice_time(@registration.checked_in_at) + "!"
      elsif not @registration.is_paid
        flash.now[:warning] = "Person has not paid yet! Resting amount: €" + @registration.to_pay.to_s
      else
        flash.now[:success] = "Person has been scanned!"
        @registration.checked_in_at = Time.now
        @registration.save!
      end
    else
      flash.now[:error] = "Barcode not found"
    end

    render action: :scan
  end

  def export_status
    @event = Event.find params.require(:id)
    authorize! :read, @event
    if @event.export_status == 'done'
      render partial: 'events/export'
    else
      redirect_to :back, status: :not_found
    end
  end

  def generate_export
    @event = Event.find params.require(:id)
    authorize! :read, @event
    @event.export_status = "generating"
    @event.save
    @event.generate_xls
  end

end
