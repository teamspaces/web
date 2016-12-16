class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin
  include User::AfterSignInPath
  include InvitationCookie

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def sign_in_path_for(_resource)
    user_sign_in_path(_resource)
  end

  def after_sign_in_path_for(_resource)
    raise "error"
    #user_after_sign_in_path
  end

  def after_sign_out_path_for(_resource)
    landing_path
  end
end
