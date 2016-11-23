module UserAfterSignInPath
  extend ActiveSupport::Concern

  def user_after_sign_in_path
    case current_user.teams.count
    when 0
      new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    when 1
      team_url(subdomain: current_user.teams.first.subdomain,
               auth_token: GenerateLoginToken.call(user: current_user))
    else
      teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end

end
