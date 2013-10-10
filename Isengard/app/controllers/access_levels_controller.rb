class AccessLevelsController < ApplicationController

  respond_to :html

  def show
    @access_level = AccessLevel.find params.require(:id)
  end

  def new
    @access_level = AccessLevel.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @access_level = @event.access_levels.create params.require(:access_level).permit(:name)
    respond_with @event
  end

  def destroy
    access_level = AccessLevel.find params.require(:id)
    @event = access_level.event
    access_level.destroy
    respond_with @event
  end

  def update
    access_level = AccessLevel.find params.require(:id)
    zones = params.require(:access_level).require(:zones)
    # Features introduced in new versions apparently suck pretty hard
    # manually parse the output here from collection_check_boxes, because rails
    access_level.set_zones_by_ids zones[0..-2].map { |z| z.split.first.to_i }
    @event = access_level.event
    respond_with @event
  end

end
