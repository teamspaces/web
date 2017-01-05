module LoginRegisterFunnel::SignInPathForUser
  include LoginRegisterFunnel::SharedUserInformation
  include LoginRegisterFunnel::UserAcceptInvitationPath
  extend ActiveSupport::Concern

  def sign_in_path_for(user, team_to_redirect_to=nil)
    DeviceUsersCookie.new(cookies).add(user)

    return user_accept_invitation_path(user) if invitation_token_cookie.present?

    team_to_redirect_to = Team.find_by(subdomain: request.subdomain) if on_users_team_subdomain?(user)

    if user_clicked_on_create_team
      login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    elsif team_to_redirect_to
      team_url(subdomain: team_to_redirect_to.subdomain, auth_token: GenerateLoginToken.call(user: user))
    else
      case user.teams.count
      when 0
        login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
      when 1
        team_url(subdomain: user.teams.first.subdomain, auth_token: GenerateLoginToken.call(user: user))
      else
        login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
      end
    end
  end

  private

    def on_users_team_subdomain?(user)
      user.teams.find_by(subdomain: request.subdomain).present?
    end
end
