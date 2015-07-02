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
    if promo.tickets_sold?
      render :index
    else
      # Save the name so we can respond it as we still have to
      # be able to delete it
      @id = promo.id
      promo.destroy
    end
  end

  def generate
    @event = Event.find params.require(:event_id)
    authorize! :update, @event
    amount = params[:amount].to_i
    limit = params[:limit].to_i
    access_levels = @event.access_levels.find(params[:access_levels].split(',')) rescue []

    if amount <= 0 || limit <= 0
      flash[:error] = 'Amount and Maximum uses should be greater than zero!'
      redirect_to event_promos_path(@event)
    elsif access_levels.blank?
      flash[:error] = 'Tickets should be specified'
      redirect_to event_promos_path(@event)
    else
      Promo.generate_bulk(amount, limit, access_levels, @event)
      redirect_to event_promos_path(@event)
    end
  end
end
