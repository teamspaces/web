class LoginRegisterFunnelController < ApplicationController
  include LoginRegisterFunnel::SharedUserInformation
  include AcceptTeamInvitation

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in

  def sign_in_path_for(user)
    case user.teams.count
    when 0
      new_team_ree_path(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    when 1
      team_url(subdomain: user.teams.first.subdomain, auth_token: GenerateLoginToken.call(user: user))
    else
      list_teams_path(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: user))
    end
  end

  private

    def redirect_if_user_already_signed_in
      #TODO
    end
end
