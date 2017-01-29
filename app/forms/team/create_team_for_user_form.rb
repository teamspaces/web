class Team::CreateTeamForUserForm < Team::Form

  def initialize(user: nil, attributes: {})
    @user = user

    super(attributes: attributes)
  end

  def save
    super && Team::AddTeamMember.call(role: TeamMember::Roles::PRIMARY_OWNER,
                                      team: @team,
                                      user: @user).success?
  end
end
