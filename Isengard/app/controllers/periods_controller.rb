class PeriodsController < ApplicationController

  respond_to :html, :js

  def show
    @period = Period.find params.require(:id)
  end

  def new
    @period = Period.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @period = @event.periods.create params.require(:period).permit(:name, :starts, :ends)
    respond_with @period
  end

  def destroy
    period = Period.find params.require(:id)
    @id = period.id
    period.destroy
    respond_with @id
  end
end
