# encoding: UTF-8

class EventsController < ApplicationController

  # order is important here, we need to be authenticated before we can check permission
  before_filter :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource only: [:new, :show, :update, :edit, :destroy]

  respond_to :html, :js, :ics

  def index
    @events = Event.where('end_date > ?', DateTime.now).order(:name)
    if user_signed_in?
      @events += Event.accessible_by(current_ability).to_a
    end
    @events.uniq!
  end

  def show
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

  def toggle_registration_open
    @event = Event.find params.require(:id)
    authorize! :update, @event

    @event.toggle_registration_open

    redirect_to action: :edit
  end

  def create
    authorize! :create, Event

    @event = Event.create params.require(:event).permit(:name, :club_id, :location, :website, :contact_email, :start_date, :end_date, :description)

    respond_with @event
  end

  def statistics
    @event = Event.find params.require(:id)
    authorize! :view_stats, @event

    if not @event.tickets.empty?

      min, max = @event.tickets.pluck(:created_at).minmax
      zeros = Hash[]
      while min <= max
        zeros[min.strftime("%Y-%m-%d")] = 0
        min += 1.day
      end

      @data = @event.access_levels.map do |al|
        {name: al.name, data: zeros.merge(al.tickets.group('date(tickets.created_at)').count)}
      end

    else
      @data = []
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

    @ticket = @event.tickets.find_by_barcode barcode

    if @ticket
      if not @ticket.order.is_paid
        flash.now[:warning] = "Person has not paid yet! Resting amount: €" + @ticket.order.to_pay.to_s
      elsif @ticket.checked_in_at
        flash.now[:warning] = "Person already checked in at " + view_context.nice_time(@ticket.checked_in_at) + "!"
      else
        flash.now[:success] = "Person has been scanned!"
        @ticket.checked_in_at = Time.now
        @ticket.save!
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
