class PartnersController < ApplicationController

  before_action :authenticate_user!, except: [:show, :confirm]
  before_action :authenticate_partner!, only: [:show, :confirm]

  respond_to :html, :js

  def index
    @event = Event.find params.require(:event_id)

    authorize! :read, @event
  end

  def show
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find_by_id params.require(:id)

    authorize! :read, @partner
  end

  def new
    @partner = Partner.new
  end

  def create
    @event = Event.find params.require(:event_id)
    authorize! :update, @event

    al = @event.access_levels.find(params.require(:partner).require(:access_level))

    @partner = @event.partners.new params.require(:partner).permit(:name, :email)
    @partner.access_level = al
    @partner.save

    @partner.deliver

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

    al = @event.access_levels.find(params.require(:partner).require(:access_level))

    @partner = @event.partners.find params.require(:id)
    @partner.access_level = al
    @partner.update params.require(:partner).permit(:name, :email)

    @partner.deliver

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
    partner.deliver
  end

  def confirm
    @event = Event.find params.require(:event_id)
    @partner = @event.partners.find_by_id params.require(:id)

    authorize! :register, @partner

    if @partner.confirmed
      flash.now[:error] = "You have already registered for this event. Please check your mailbox."
    else
      @registration = @event.registrations.new(
        email:          @partner.email,
        name:           @partner.name,
        student_number: nil,
        comment:        nil,
        price:          @partner.access_level.price,
        paid:           0
      )
      @registration.access_levels << @partner.access_level
      @partner.confirmed = true
      if @registration.save and @partner.save then
        @registration.deliver
        flash.now[:success] = "Your invitation has been confirmed. Your ticket should arrive shortly."
      else
        flash.now[:error] = "Something went horribly wrong. Try again or contact us."
      end
    end
  end

end
