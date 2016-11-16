class Team::CreateTeamForUser
  include Interactor

  def call
    context.team = Team.new(context.team_params)
    team_member = context.user.team_members.new(team: context.team,
                                                role: TeamMember::Roles::PRIMARY_OWNER)

    context.fail! unless team_member.save
  end
end
