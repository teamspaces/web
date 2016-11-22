class SpacePolicy::Scope
  attr_reader :team, :scope

  def initialize(default_context, scope)
    @team = default_context.team
    @scope = scope
  end

  def resolve
    scope.where(team: team)
  end
end
