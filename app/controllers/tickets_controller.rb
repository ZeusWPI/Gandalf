class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destroy, :resend, :update, :email, :upload]

  require 'csv'

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event

    @ticketsgrid = TicketsGrid.new(params[:tickets_grid]) do |scope|
      scope.where(event_id: @event.id)
    end

    @tickets = @ticketsgrid.assets
    @tickets = @tickets.paginate(page: params[:page], per_page: 25)
  end

  def new
    @event = Event.find params.require(:event_id)
    @tickets = Ticket.new
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :destroy, @event
    ticket = Ticket.find params.require(:id)
    @id = ticket.id
    ticket.destroy
  end

  def info
    @ticket = Ticket.find params.require(:id)
    authorize! :read, @ticket.event
  end

  def resend
    @ticket = Ticket.find params.require(:id)
    authorize! :update, @ticket.event

    TicketMailer.ticket(@ticket).deliver_now
  end

  def create
  end

  def update
    @ticket = Ticket.find params.require(:id)
    respond_with @ticket
  end

  def email
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
    to_id = params['to'].to_i
    if to_id == -1
      to = @event.tickets.pluck(:email)
    else
      to = @event.access_levels.find_by_id(to_id).tickets.pluck(:email)
    end
    MassMailer.general_message(@event.contact_email, to, params['email']['subject'], params['email']['body']).deliver_now
    redirect_to event_tickets_path(@event)
  end
end
