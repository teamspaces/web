class LoginRegisterFunnel::LoginIntoTeamController < LoginRegisterFunnelController

  skip_before_action :redirect_if_user_already_signed_in

  def new
    return redirect_to(team_path) if already_signed_in_on_team_subdomain?

    user = user_trying_to_login_on_team_subdomain

    redirect_to case
      when user.login_using_slack? then team_slack_login_path(subdomain_team)
      when user.login_using_email? then team_email_login_path(user)
    end
  end

  private

    def already_signed_in_on_team_subdomain?
      current_user.present?
    end

    def subdomain_team
      Team.find_by(subdomain: request.subdomain)
    end

    def user_trying_to_login_on_team_subdomain
      subdomain_team.users.find_by(id: AvailableUsersCookie.new(cookies).users)&.decorate
    end

    def team_slack_login_path(team)
      user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], state: :login, team_id: team.id)
    end

    def team_email_login_path(user)
      shared_user_info.reviewed_email_address = user.email

      new_email_login_path
    end
end
