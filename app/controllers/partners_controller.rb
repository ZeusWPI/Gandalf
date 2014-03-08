class PartnersController < ApplicationController
  before_action :authenticate_user!, except: :show

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def new
  end

  def create
  end
end
