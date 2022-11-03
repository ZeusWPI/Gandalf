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

  def toggle_visibility
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @access_level = AccessLevel.find params.require(:id)
    @access_level.hidden = !@access_level.hidden
    @access_level.save!
  end

  private

  def access_level_params
    params.require(:access_level).permit(:name, :capacity, :price, :has_comment, :hidden, :permit)
  end
end
