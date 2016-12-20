module User::SignInPath
  extend ActiveSupport::Concern
  include AcceptTeamInvitation
  include UserTeamsFunnel::CurrentUser
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo

  def user_sign_in_path(user)
    accept_team_invitation(user) if invitation_cookie.present?

    return create_new_team_path(user) if after_sign_in_action == :create_team

    return team_url(subdomain: users_team_subdomain(user),
                    auth_token: GenerateLoginToken.call(user: user)) if users_team_subdomain(user).present?

    case user.teams.count
    when 0
      create_new_team_path(user)
    when 1
      team_url(subdomain: user.teams.first.subdomain,
               auth_token: GenerateLoginToken.call(user: user))
    else
      list_users_teams_path(user)
    end
  end

  private

    def users_team_subdomain(user)
      user.teams.find_by(subdomain: request.subdomain)&.subdomain
    end

    def create_new_team_path(user)
      set_user_teams_funnel_current_user(user)

      user_teams_funnel_create_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end

    def list_users_teams_path(user)
      set_user_teams_funnel_current_user(user)

      user_teams_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
end
