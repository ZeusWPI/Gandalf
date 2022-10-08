# frozen_string_literal: true

class PeriodsController < ApplicationController
  # You need to be logged in for everything.
  before_action :authenticate_user!

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  def show
    @period = Period.find params.require(:id)
    authorize! :read, @period.event
  end

  def new
    @period = Period.new
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @period = @event.periods.create!(params.require(:period).permit(:name, :starts, :ends))
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    period = Period.find params.require(:id)
    @id = period.id
    period.destroy!
  end
end
