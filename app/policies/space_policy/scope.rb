class SpacePolicy
  class Scope

    attr_reader :team_policy_context, :scope

    def initialize(team_policy_context, scope)
      @team_policy_context = team_policy_context
      @scope = scope
    end

    def resolve
      scope.where(team: @team_policy_context.team)
    end
  end
end
