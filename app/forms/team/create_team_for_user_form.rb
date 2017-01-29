class Team::CreateTeamForUserForm < Team::Form

  def initialize(user: nil, team_params: {})
    @user = user

    super(params: team_params)
  end

  def save
    super && Team::AddTeamMember.call(role: TeamMember::Roles::PRIMARY_OWNER,
                                      team: @team,
                                      user: @user).success?
  end
end
