class CallbacksController < Devise::OmniauthCallbacksController
  def zeuswpi
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
