class CreateTeamMemberForNewTeam
  include Interactor

  def call
    context.team_member = context.user.team_members.new(team: context.team,
                                                        role: TeamMember::Roles::PRIMARY_OWNER)
    context.fail! unless context.team_member.save
  end
end
