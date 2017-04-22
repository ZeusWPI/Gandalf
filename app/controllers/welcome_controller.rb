class WelcomeController < ApplicationController
  def index
    redirect_to event_path(Event.first)
  end
end
