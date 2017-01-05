class LoginRegisterFunnel::UserAccessTeamController < LoginRegisterFunnelController
  #login_into_team
  include SignedInUsersCookie

  def new
    if current_user
      redirect_to team_path
    else
      current_team = Team.find_by(subdomain: request.subdomain)
      user = current_team.users.find_by(id: signed_in_users_cookie_users)&.decorate

      if user.login_using_slack?
        redirect_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], state: :login, team_id: current_team.id)
      elsif user.login_using_email?
        set_users_reviewed_email_address(current_user.email)

        redirect_to new_email_login_path
      end
    end
  end

end
