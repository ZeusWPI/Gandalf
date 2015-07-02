class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :store_location

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ %r{/users}
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url] || root_path
  end

  def current_ability
    if current_partner
      @current_ability ||= Ability.new(current_partner)
    else
      @current_ability ||= Ability.new(current_user)
    end
  end
end
