class RegistrationsController < ApplicationController

  respond_to :html

  def new
    @event = Event.find params.require(:event_id)
    registration = Registration.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name, :zone_accesses)
    params.require(:registration).require(:zone_accesses).each do |key, value|
      logger.debug value
    end
    respond_with @registration
  end

end
