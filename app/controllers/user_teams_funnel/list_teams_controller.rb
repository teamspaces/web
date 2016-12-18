class UserTeamsFunnel::ListTeamsController < UserTeamsFunnelController

  def index
    @user = user_teams_funnel_current_user
  end

end
