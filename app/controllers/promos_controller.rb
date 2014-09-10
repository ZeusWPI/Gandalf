class PromosController < ApplicationController

  before_action :authenticate_user!, except: [:show, :confirm]

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  def edit
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @promo = @event.promos.find(params.require(:id))
    respond_with @promo
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @promo = @event.promos.new update_params
    @promo.access_levels = @promo.event.access_levels.where(id: params.require(:promo)[:access_levels].split(','))
    @promo.save
    respond_with @promo
  end

  def update
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    @promo = @event.promos.find(params.require(:id))
    @promo.update update_params
    @promo.access_levels = @promo.event.access_levels.where(id: params.require(:promo)[:access_levels].split(','))

    respond_with @promo
  end

  def update_params
    params.require(:promo).permit(:code, :limit)
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    promo = @event.promos.find(params.require(:id))
    unless promo.tickets_sold?
      # Save the name so we can respond it as we still have to
      # be able to delete it
      @id = promo.id
      promo.destroy
    else
      render :index
    end
  end

end
