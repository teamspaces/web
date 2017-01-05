module LoginRegisterFunnel::SignInPathForUser
  include LoginRegisterFunnel::SharedUserInformation
  include LoginRegisterFunnel::UserAcceptInvitationPath
  include SignedInUsersCookie
  extend ActiveSupport::Concern

  def sign_in_path_for(user)
    add_to_signed_in_users_cookie(user)
    return user_accept_invitation_path(user) if invitation_token_cookie.present?

    if user_clicked_on_create_team
      login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    elsif on_team_subdomain_of_user(user)
      team_path(auth_token: GenerateLoginToken.call(user: user))
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

    def on_team_subdomain_of_user(user)
      user.teams.find_by(subdomain: request.subdomain).present?
    end
end
