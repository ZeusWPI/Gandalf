class RegistrationsController < ApplicationController

  respond_to :html

  def new
    @event = Event.find params.require(:event_id)
    registration = Registration.new
  end

  def create
    @event = Event.find params.require(:event_id)
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name)
    params.require(:registration).require(:checkboxes).each do |access_level, periods|
      periods.each do |period, checked|
        if checked = "on" then
          access = @registration.accesses.build access_level_id: access_level, period_id: period
          access.save
        end
      end
    end
    render 'registrations/confirm'
  end

end
