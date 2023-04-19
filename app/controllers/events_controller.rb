# frozen_string_literal: true

class EventsController < ApplicationController
  # order is important here, we need to be authenticated before we can check permission
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource only: [:new, :show, :update, :edit, :destroy]

  respond_to :html, :js, :ics

  def index
    @events = Event.where('end_date > ?', DateTime.now).order(:start_date)
    @past_events = if user_signed_in?
                     Event.accessible_by(current_ability).order(:name)
                   else
                     []
                   end
  end

  def show
    @registration = @event.registrations.build

    return unless current_user

    @registration.name = current_user.display_name
    @registration.student_number = current_user.cas_ugentStudentID
    @registration.email = current_user.cas_mail

    respond_to do |format|
      format.html { render :show }
      format.ics { render plain: GenerateIcal.new(@event).call }
    end
  end

  def new; end

  def edit; end

  def destroy
    @event.destroy!
    redirect_to action: :index
  end

  def update
    authorize! :update, @event

    flash.now[:success] = "Successfully updated event." if @event.update(event_params)

    render action: :edit
  end

  def toggle_registration_open
    @event = Event.find params.require(:id)
    authorize! :update, @event

    @event.toggle_registration_open

    redirect_to action: :edit
  end

  def create
    authorize! :create, Event

    @event = Event.new(event_create_params)
    flash.now[:success] = "Successfully created event." if @event.save

    respond_with @event
  end

  def statistics
    @event = Event.find params.require(:id)
    authorize! :view_stats, @event

    if @event.registrations.empty?
      @data = []
    else

      min, max = @event.registrations.pluck(:created_at).minmax
      zeros = {}
      while min <= max
        zeros[min.strftime("%Y-%m-%d")] = 0
        min += 1.day
      end

      @data = @event.access_levels.map do |al|
        {
          name: al.name,
          data: zeros.merge(al.registrations.group('date(registrations.created_at)').count.transform_keys { |key| key.strftime("%Y-%m-%d") })
        }
      end

    end
  end

  def scan
    @event = Event.find params.require(:id)
    authorize! :update, @event
  end

  def scan_barcode
    @event = Event.find params.require(:id)
    authorize! :update, @event
    @registration = @event.registrations.find_by barcode: params.require(:code)
    check_in
  end

  def scan_name
    @event = Event.find params.require(:id)
    authorize! :update, @event
    @registration = @event.registrations.find_by name: params.require(:name)
    check_in
  end

  def export_status
    @event = Event.find params.require(:id)
    authorize! :read, @event
    if @event.export_status == 'done'
      render partial: 'events/export'
    else
      redirect_back(fallback_location: @show, status: :not_found)
    end
  end

  def generate_export
    @event = Event.find params.require(:id)
    authorize! :read, @event

    @event.update!(export_status: 'queueing')

    GenerateRegistrationsXlsJob.perform_later(@event.id)
  end

  def list_registrations
    @event = Event.find params.require(:id)
    authorize! :read, @event
    render json: @event.registrations
  end

  private

  def check_in
    if @registration
      if !@registration.paid?
        flash.now[:warning] =
          "Person has not paid yet! Resting amount: €#{@registration.to_pay}"
      elsif @registration.checked_in_at
        flash.now[:warning] = "Person already checked in at #{view_context.nice_time(@registration.checked_in_at)}!"
      else
        flash.now[:success] = "Person has been scanned!"
        @registration.checked_in_at = Time.zone.now
        @registration.save!
      end
    else
      flash.now[:error] = "Registration not found"
    end
    render action: :scan
  end

  def event_params
    params.require(:event).permit(
      :name,
      :location,
      :website,
      :contact_email,
      :start_date,
      :end_date,
      :description,
      :bank_number,
      :registration_close_date,
      :registration_open_date,
      :show_ticket_count,
      :signature,
      :require_physical_ticket
    )
  end

  def event_create_params
    params.require(:event).permit(
      :name,
      :club_id,
      :location,
      :website,
      :contact_email,
      :start_date,
      :end_date,
      :description,
      :require_physical_ticket
    )
  end
end
