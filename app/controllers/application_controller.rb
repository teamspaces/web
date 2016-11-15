class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(_resource)
    teams_path
  end

  def after_sign_out_path_for(_resource)
    landing_path
  end

  def current_team_member
    if current_user && @team
      current_user.team_members.find_by(team: @team)
    end
  end
end
