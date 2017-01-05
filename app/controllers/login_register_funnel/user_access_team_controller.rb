class LoginRegisterFunnel::UserAccessTeamController < LoginRegisterFunnelController
  #login_into_team

  def new
    if current_user
      redirect_to team_path
    else
      current_team = Team.find_by(subdomain: request.subdomain)
      user = current_team.users.find_by(id: DeviceUsersCookie.new(cookies).users)&.decorate

      if user.login_using_slack?
        redirect_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], state: :login, team_id: current_team.id)
      elsif user.login_using_email?
        set_users_reviewed_email_address(user.email)

        redirect_to new_email_login_path
      end
    end
  end
end
