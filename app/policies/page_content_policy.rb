class PageContentPolicy
  attr_reader :page_policy_context,
              :page_content,
              :page_policy

  def initialize(page_policy_context, page_content)
    @page_policy_context = page_policy_context
    @page_content = page_content
    @page_policy = PagePolicy.new(@page_policy_context, @page_content.page)
  end

  def show?
    @page_policy.show?
  end

  def update?
    @page_policy.update?
  end
end
