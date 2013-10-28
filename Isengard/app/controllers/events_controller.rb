class EventsController < ApplicationController

  # order is important here, we need to be authenticated before we can check permission
  before_filter :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource only: [:new, :show, :update, :edit, :destroy]

  respond_to :html, :js

  def index
    @events = Event.all.order(:name)
  end

  def show
  end

  def new
  end

  def edit
  end

  def destroy
    @event.destroy
    redirect_to :back
  end

  def registration_times
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    if @event.update params.require(:event).permit(:registration_close_date, :registration_open_date)
      flash[:notice] = "succesfully updated registration times"
    else
      flash[:error] = "something went wrong"
    end
    respond_with @event
  end

  def update
    @event.update params.require(:event).permit(:name, :organisation, :location, :website, :start_date, :end_date, :description)
    respond_with @event
  end

  def create
    authorize! :create, Event
    @event = Event.create(params.require(:event).permit(:name, :organisation, :location, :website, :start_date, :end_date, :description).merge club: current_user.club)
    respond_with @event
  end

end
