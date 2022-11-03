# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :restrict_to_development

  def login
    u = User.find_or_create_by!(username: "tnnaesse", admin: true)
    u.clubs = [Club.find_or_create_by!(internal_name: 'zeus', full_name: 'Zeus WPI', display_name: 'Zeus WPI')]
    sign_in(u)

    redirect_to '/'
  end

  protected

  # this method should be placed in ApplicationController
  def restrict_to_development
    head(:bad_request) unless Rails.env.development?
  end
end
