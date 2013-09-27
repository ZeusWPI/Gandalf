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

end
