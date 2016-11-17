class PagePolicy
  class Scope

    attr_reader :space_policy_context, :scope

    def initialize(space_policy_context, scope)
      @space_policy_context = space_policy_context
      @scope = scope
    end

    def resolve
      scope.where(space: space_policy_context.space)
    end
  end
end
