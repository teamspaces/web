class UserTeamsQuery

  def initialize(relation)
    @relation = relation
  end

  def recently_created_team
    @relation.teams
             .joins(:members)
             .find_by(team_members: { role: TeamMember::Roles::PRIMARY_OWNER },
                      teams: { created_at: (Time.now - 5.hours)..Time.now })
  end
end
