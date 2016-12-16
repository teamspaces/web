module User::SignInPath
  extend ActiveSupport::Concern
  include AcceptTeamInvitation

  def user_sign_in_path(user)
    accept_team_invitation(user) if invitation_cookie.present?

    case user.teams.count
    when 0
      new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    when 1
      if request_with_team_subdomain?
        team_path
      else
        team_url(subdomain: user.teams.first.subdomain,
                 auth_token: GenerateLoginToken.call(user: user))
      end
    else
      if request_with_team_subdomain?
        team_path
      else
        teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  private

    def request_with_team_subdomain?
      user.teams.map(&:subdomain).include?(request.subdomain)
    end
end
