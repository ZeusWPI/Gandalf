class EventsController < ApplicationController

  def show
    @event = Event.find params.require(:id)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new params.require(:event).permit(:name, :organisation, :location, :website, :start_date, :end_date, :description)
    if @event.save
      redirect_to @event
    else
      render "new"
    end
  end

end
