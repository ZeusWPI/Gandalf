class InvitationsController < ApplicationController

  before_action :authenticate_user!, except: :show

  respond_to :html, :js

  def show
    @invitation = Invitation.find params.require(:id)
    # TODO authorize has pretty token
  end

  def new
    @invitation = Invitation.new
  end

  def create
    @partner = Partner.find params.require(:partner_id)
    @event = @partner.event
    authorize! :update, @event

    @invitation = @partner.received_invitations.create params.require(:invitation).permit(:access_level_id)
    respond_with @invitation
  end

end
