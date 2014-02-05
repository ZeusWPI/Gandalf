class PeriodsController < ApplicationController

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
  end

  def show
    @period = Period.find params.require(:id)
  end

  def new
    @period = Period.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @period = @event.periods.create params.require(:period).permit(:name, :starts, :ends)
  end

  def destroy
    @event = Event.find params.require(:event_id)
    period = Period.find params.require(:id)
    @id = period.id
    period.destroy
  end
end
