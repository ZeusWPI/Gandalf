class ZonesController < ApplicationController

  # You need to be logged in for everything.
  before_action :authenticate_user!, except: :show

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  def show
    @zone = Zone.find params.require(:id)
  end

  def new
    @zone = Zone.new
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @zone = @event.zones.create params.require(:zone).permit(:name)
  end

  def destroy
    zone = Zone.find params.require(:id)
    @id = zone.id
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    zone.destroy
  end

end
