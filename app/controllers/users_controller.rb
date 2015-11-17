class UsersController < ApplicationController
  before_filter :restrict_to_development

  def login
    redirect_to '/'
  end

  protected
  # this method should be placed in ApplicationController
  def restrict_to_development
    head(:bad_request) unless Rails.env.development?
  end
end
