module User::SignInPath
  extend ActiveSupport::Concern
  include AcceptTeamInvitation

  def user_sign_in_path(user)
    accept_team_invitation(user) if invitation_cookie.present?

    case user.teams.count
    when 0
      sign_in user
      new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    when 1
      team_url(subdomain: user.teams.first.subdomain,
               auth_token: GenerateLoginToken.call(user: user))
    else
      teams_url(subdomain: user.teams.first.subdomain,
                auth_token: GenerateLoginToken.call(user: user))
    end
  end
end
