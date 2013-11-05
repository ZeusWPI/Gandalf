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
    authorize! :register, @event
    @registration = @event.registrations.create params.require(:registration).permit(:email, :name, :student_number)
    @registration.access_levels << @event.access_levels.find(params.require(:registration).require(:access_levels))
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
    begin
      raise "Invalid update" unless @registration.update params.require(:registration).permit(:paid)
      flash[:notice] = "succesfully updated"
    rescue
      flash[:error] = "something went wrong"
    end
    respond_with @registration.event
  end

end
