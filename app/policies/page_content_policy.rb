class PageContentPolicy

  attr_reader :page_policy

  # Gleich Page Policy in Controller verwenden

  def initialize(default_context, page_content)
    @team = default_context.team
    @user = default_context.user
    @space = page_content.page.space

    page_policy_context = PagePolicy::Context.new(@user, @team, @space)

    @page_policy = PagePolicy.new(page_policy_context, page_content.page)
  end

  def show?
    page_policy.show?
  end

  def update?
    page_policy.update?
  end
end
