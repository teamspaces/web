module LoginRegisterFunnel::SignInPathForUser
  include LoginRegisterFunnel::SharedUserInformation
  include LoginRegisterFunnel::UserAcceptInvitationPath
  extend ActiveSupport::Concern

  def sign_in_path_for(user, team_to_redirect_to=nil)
    AvailableUsersCookie.new(cookies).add(user)

    case
      when invitation_token_cookie.present? then user_accept_invitation_path(user)
      when user_clicked_on_create_team then team_creation_path(user)
      when team_to_redirect_to.present? then team_to_redirect_to_path(user, team_to_redirect_to)
      else path_depending_on_user_teams_count(user) end
  end

  private

    def team_creation_path(user)
      login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    end

    def team_to_redirect_to_path(user, team)
      team_url(subdomain: team.subdomain, auth_token: GenerateLoginToken.call(user: user))
    end

    def path_depending_on_user_teams_count(user)
      case user.teams.count
        when 0
          team_creation_path(user)
        when 1
          team_to_redirect_to_path(user, user.teams.first)
        else
          login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
      end
    end
end
