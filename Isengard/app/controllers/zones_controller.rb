class ZonesController < ApplicationController

  respond_to :html

  def show
    @zone = Zone.find params.require(:id)
  end

  def new
    @zone = Zone.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @zone = @event.zones.create params.require(:zone).permit(:name)
    respond_with @event
  end

  def destroy
    zone = Zone.find params.require(:id)
    @event = zone.event
    zone.destroy
    respond_with @event
  end

end
