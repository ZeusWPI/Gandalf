# frozen_string_literal: true

class AccessLevelsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  respond_to :html, :js

  def show
    @access_level = AccessLevel.find params.require(:id)
  end

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @access_level = @event.access_levels.new(access_level_params)

    flash.now[:error] = "Something went wrong creating the ticket" unless @access_level.save

    respond_with @access_level
  end

  def edit
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @access_level = @event.access_levels.find(params.require(:id))
    respond_with @access_level
  end

  def update
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @access_level = @event.access_levels.find(params.require(:id))

    flash.now[:error] = "Something went wrong updating the ticket" unless @access_level.update(access_level_params)

    respond_with @access_level
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    access_level = AccessLevel.find params.require(:id)
    if access_level.registrations.any?
      render :index
    else
      # Save the name so we can respond it as we still have to
      # be able to delete it
      @id = access_level.id
      access_level.destroy!
    end
  end

  def set_zones
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    access_level = AccessLevel.find params.require(:access_level_id)
    zones = params.require(:access_level).require(:zones)
    # Features introduced in new versions apparently suck pretty hard
    # manually parse the output here from collection_check_boxes, because rails
    access_level.zones_by_ids = zones[0..-2].map { |z| z.split.first.to_i }
    redirect_to @event
  end

  def toggle_visibility
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @access_level = AccessLevel.find params.require(:id)
    @access_level.hidden = !@access_level.hidden
    @access_level.save!
  end

  def parse_advanced
    @advanced = params[:advanced] == 'true'
  end

  private

  def access_level_params
    params.require(:access_level).permit(:name, :capacity, :price, :has_comment, :hidden, :permit)
  end
end
