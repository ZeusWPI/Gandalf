class WelcomeController < ApplicationController
  def index
    event = Event.find_by_id(5)
    if event != nil
      redirect_to event_path(Event.first)
    end
  end
end
