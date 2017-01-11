class WelcomeController < ApplicationController
  def index
    if Event.first
      redirect_to event_path(Event.first)
    end
  end
end
