class SpacePolicy::Scope

  attr_reader :default_context, :scope

  def initialize(default_context, scope)
    @default_context = default_context
    @scope = scope
  end

  def resolve
    scope.where(team: default_context.team)
  end
end
