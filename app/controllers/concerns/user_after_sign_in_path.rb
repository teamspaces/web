module UserAfterSignInPath
  extend ActiveSupport::Concern

  def user_after_sign_in_path
    accept_team_invitation if invitation_cookie.present?

    case current_user.teams.count
    when 0
      new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    when 1
      if request_with_team_subdomain?
        team_path
      else
        team_url(subdomain: current_user.teams.first.subdomain,
                 auth_token: GenerateLoginToken.call(user: current_user))
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
      current_user.teams.map(&:subdomain).include?(request.subdomain)
    end

end
