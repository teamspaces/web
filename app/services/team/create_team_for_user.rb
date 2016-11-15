class Team::CreateTeamForUser

  def self.call(team_params, user)
    team = Team.new(team_params)
    team_member = user.team_members.new(team: team,
                                        role: TeamMember::Roles::PRIMARY_OWNER)

    if team_member.save
      [true, team]
    else
      [false, team]
    end
  end
end
