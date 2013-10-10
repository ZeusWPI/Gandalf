class IncludedZonesController < ApplicationController

  respond_to :html

  def create
    access_level = AccessLevel.find params.require(:access_level_id)
    included_zone = access_level.included_zones.create params.require(:included_zone).permit(:zone_id)
    @event = access_level.event
    respond_with @event
  end

  def destroy
    included_zone = IncludedZone.find params.require(:id)
    @event = included_zone.access_level.event
    included_zone.destroy
    respond_with @event
  end

end
