class SignInIntoTeamSubdomainController < SubdomainBaseController

  def new
    team = current_user.teams.find_by(subdomain: params[:team_subdomain])

    redirect_to team_url(subdomain: team.subdomain, auth_token: GenerateLoginToken.call(user: current_user))
  end
end
