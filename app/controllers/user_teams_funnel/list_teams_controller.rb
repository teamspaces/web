class UserTeamsFunnel::ListTeamsController < UserTeamsFunnelController

  def index
    @teams = @user.teams
  end
end
