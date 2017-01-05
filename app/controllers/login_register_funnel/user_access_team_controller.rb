class LoginRegisterFunnel::UserAccessTeamController < LoginRegisterFunnelController
  include SignedInUsersCookie

  def new
    if current_user
      redirect_to team_path
    else
      current_team = Team.find_by(subdomain: request.subdomain)
      user = current_team.users.find_by(id: signed_in_users_cookie_users)&.decorate

      if user.login_using_slack?
        redirect_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], state: :login)
      elsif user.login_using_email?
        set_users_reviewed_email_address(user.email)
        new_email_login_path
      end
    end
  end

end
