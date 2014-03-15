class SignInController < ApplicationController
  acts_as_token_authentication_handler_for Partner

  before_action :authenticate_partner!

  def sign_in_partner
    @event = Event.find params.require(:event_id)

    redirect_to event_partner_path(@event, current_partner)
  end

end
