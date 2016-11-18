class PagePolicy
  include AliasMethods

  attr_reader :page_policy_context, :page


  def initialize(page_policy_context, page)
    @page_policy_context = page_policy_context
    @page = page
  end

  alias_methods :team_page?, [:show?, :new?, :edit?, :create?, :update?, :destroy?]

  def index?
    page_policy_context.team == page_policy_context.space.team
  end

  def team_page?
    page_policy_context.team == page.team
  end
end
