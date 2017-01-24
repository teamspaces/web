class Team::CreateTeamMember
  include Interactor

  def call
    context.team_member = context.user.team_members.new(team: context.team,
                                                        role: TeamMember::Roles::MEMBER)
    context.fail! unless context.team_member.save
  end
end
