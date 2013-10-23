class PeriodsController < ApplicationController

  respond_to :html

  def show
    @period = Period.find params.require(:id)
  end

  def new
    @period = Period.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @period = @event.periods.create params.require(:period).permit(:name, :starts, :ends)
    redirect_to @event
  end

  def destroy
    period = Period.find params.require(:id)
    @event = period.event
    period.destroy
    respond_with @event
  end
end
