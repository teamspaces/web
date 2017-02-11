class SpacePolicy::Scope
  attr_reader :team, :user, :scope

  def initialize(default_context, scope)
    @team = default_context.team
    @user = default_context.user

    @scope = scope
  end

  def resolve
    scope.where(team: team, access_control_rule: Space::AccessControlRules::TEAM)
         .or(private_user_spaces)
  end

  def private_user_spaces
    Space.joins(:space_members)
         .where(team: team,
                access_control_rule: Space::AccessControlRules::PRIVATE,
                space_members: { team_member: user})
  end
end



