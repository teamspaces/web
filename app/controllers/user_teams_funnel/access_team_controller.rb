class UserTeamsFunnel::AccessTeamController < UserTeamsFunnelController

  def new
    team = @user.teams.find_by(subdomain: params[:team_subdomain])

    remove_user_teams_funnel_current_user
    redirect_to team_url(subdomain: team.subdomain, auth_token: GenerateLoginToken.call(user: @user))
  end
end
