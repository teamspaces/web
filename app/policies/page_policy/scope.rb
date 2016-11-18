class PagePolicy::Scope
  attr_reader :page_policy_context, :scope

  def initialize(page_policy_context, scope)
    @space = page_policy_context.space
    @scope = scope
  end

  def resolve
    scope.where(space: space)
  end
end
