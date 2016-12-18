module User::SignInPath
  extend ActiveSupport::Concern
  include AcceptTeamInvitation
  include UserTeamsFunnel::CurrentUser

  def user_sign_in_path(user)
    accept_team_invitation(user) if invitation_cookie.present?



    case user.teams.count
    when 0
      set_user_teams_funnel_current_user(user)

      user_teams_funnel_create_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    when 1
      team_url(subdomain: user.teams.first.subdomain,
               auth_token: GenerateLoginToken.call(user: user))
    else
      set_user_teams_funnel_current_user(user)

      user_teams_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end
end
