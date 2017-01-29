class Team::AddTeamMember
  include Interactor

  def call
    team = context.team
    user = context.user
    role = context.role

    context.team_member = user.team_members.new(team: team, role: role)
    context.fail! unless context.team_member.save
  end
end


