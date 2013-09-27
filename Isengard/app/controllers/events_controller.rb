class EventsController < ApplicationController

  respond_to :html

  def show
    @event = Event.find params.require(:id)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create params.require(:event).permit(:name, :organisation, :location, :website, :start_date, :end_date, :description)
    respond_with @event
  end

end
