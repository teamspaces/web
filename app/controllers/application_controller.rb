class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    team_path
  end

  def after_sign_out_path_for(_resource)
    landing_path
  end
end
