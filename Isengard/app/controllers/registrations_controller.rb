class RegistrationsController < ApplicationController

  respond_to :html, :js

  def new
    @event = Event.find params.require(:event_id)
    @registration = Registration.new
  end

  def basic
    @event = Event.find params.require(:event_id)
    authorize! :register, @event
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name, :student_number)
    respond_with @registration
  end

  def advanced
    @event = Event.find params.require(:event_id)
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name)
    params.require(:registration).require(:checkboxes).each do |access_level, periods|
      periods.each do |period, checked|
        if checked == "on" then
          access = @registration.accesses.build access_level_id: access_level, period_id: period
          access.save
        end
      end
    end
  end

  def update
    @registration = Registration.find params.require(:id)
    authorize! :update, @registration
    logger.debug(@registration)
    @registration.update params.require(:registration).permit(:paid_cents)
    Rails.logger.info(@registration.errors.inspect)
    logger.debug(@registration)
    @event = @registration.event
    respond_with @event
  end

end
