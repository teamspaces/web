module LoginRegisterFunnel::SignInPathForUser
  extend ActiveSupport::Concern

  def sign_in_path_for(user)
    if user_clicked_on_create_team
      new_team_ree_path(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    else
      case user.teams.count
      when 0
        new_team_ree_path(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
      when 1
        team_url(subdomain: user.teams.first.subdomain, auth_token: GenerateLoginToken.call(user: user))
      else
        list_teams_path(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
      end
    end
  end

end