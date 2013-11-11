class RegistrationsController < ApplicationController

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
  end

  def new
    @event = Event.find params.require(:event_id)
    @registration = Registration.new
  end

  def basic
    @event = Event.find params.require(:event_id)

    # Check if the user can register
    authorize! :register, @event
    requested_access_level = @event.access_levels.find(params.require(:registration).require(:access_levels))
    authorize! :register, requested_access_level

    # Make the registration
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name, :student_number)
    @registration.access_levels << requested_access_level
    @registration.update paid: 0, price: requested_access_level.price

    # Send the confirmation email.
    RegistrationMailer.confirm_registration(@registration).deliver

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
    @registration.update params.require(:registration).permit(:paid)
    respond_with @registration
  end

end
