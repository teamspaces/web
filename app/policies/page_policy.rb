class PagePolicy

  attr_reader :page_policy_context, :page

  def initialize(page_policy_context, page)
    @page_policy_context = page_policy_context
    @page = page
  end

  def index?
    page_policy_context.team == page_policy_context.space.team
  end

  def team_page?
    page_policy_context.team == page.team
  end

  [:show?, :new?, :edit?,:create?,:update?, :destroy?].each do |alt|
    alias_method alt, :team_page?
  end
end
