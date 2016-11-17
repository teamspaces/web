class ApplicationController < ActionController::Base
  include HTTPBasicAuthentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    team_url(subdomain: current_user.teams.first.name)
  end

  def after_sign_out_path_for(_resource)
    landing_path
  end

  def set_team
    @team = current_user.teams.find_by_name(request.subdomain)
    unless @team
       redirect_to teams_url(subdomain: "")
    end
  end
end
