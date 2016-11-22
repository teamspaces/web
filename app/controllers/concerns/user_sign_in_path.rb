module UserSignInPath
  extend ActiveSupport::Concern

  def user_sign_in_path
    case current_user.teams.count
    when 0
      new_team_url(subdomain: "")
    when 1
      team_url(subdomain: current_user.teams.first.subdomain,
               auth_token: GenerateLoginToken.call(user: current_user))
    else
      teams_url(subdomain: "")
    end
  end

end
