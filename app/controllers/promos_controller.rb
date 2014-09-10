class PromosController < ApplicationController

  before_action :authenticate_user!, except: [:show, :confirm]

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end
end
