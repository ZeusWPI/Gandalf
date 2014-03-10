class PartnersController < ApplicationController
  before_action :authenticate_user!, except: :show

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)
    authorize! :read, @event
  end

  # def show
  #   @event = Event.find params.require(:event_id)
  #   # TODO authorize has pretty token

  #   @partner = @event.partners.find params.require(:id)
  # end

  def new
    @partner = Partner.new
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.create params.require(:partner).permit(:name, :email)
    respond_with @partner
  end

  def edit
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    respond_with @partner
  end

  def update
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    @partner.update params.require(:partner).permit(:name, :email)
    respond_with @partner
  end

  def destroy
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    @partner = @event.partners.find params.require(:id)
    @partner.destroy
  end

  def resend
    @event = Event.find params.require(:event_id)
    authorize! :read, @event

    partner = @event.partners.find params.require(:id)
    PartnerMailer.send_token(partner).deliver
  end

end
