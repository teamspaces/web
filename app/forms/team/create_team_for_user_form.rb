class Team::CreateTeamForUserForm < Team::Form

  def initialize(user: nil, team_params: {})
    @user = user

    super(params: team_params)
  end

  def save
    super && CreateTeamMemberForNewTeam.call(user: @user, team: @team).success?
  end
end
