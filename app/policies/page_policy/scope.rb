class PagePolicy::Scope

  attr_reader :page_policy_context, :scope

  def initialize(page_policy_context, scope)
    @page_policy_context = page_policy_context
    @scope = scope
  end

  def resolve
    scope.where(space: page_policy_context.space)
  end
end
