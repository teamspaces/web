class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    if current_user.teams.count > 1
      teams_url(subdomain: "")
    elsif current_user.teams.first
      team_url(subdomain: current_user.teams.first.subdomain, auth_token: GenerateLoginToken.call(user: current_user))
    else
      new_team_url(subdomain: "")
    end
  end

  def after_sign_out_path_for(_resource)
    landing_url(subdomain: "")
  end
end
