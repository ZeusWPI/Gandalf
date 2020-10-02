class UsersController < ApplicationController
  before_action :restrict_to_development

  def login
    u = User.find_or_create_by(username: "tnnaesse", admin: true)
    u.clubs = Club.where(internal_name: 'zeus')
    sign_in(u)

    redirect_to '/'
  end

  protected
  # this method should be placed in ApplicationController
  def restrict_to_development
    head(:bad_request) unless Rails.env.development?
  end
end
