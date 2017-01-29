class PagePolicy
  extend AliasMethods

  attr_reader :team, :space, :page

  def initialize(page_policy_context, page)
    @team = page_policy_context.team
    @space = page_policy_context.space
    @page = page
  end

  def index?
    team == space.team
  end

  def team_page?
    team == page.team
  end

  alias_methods :team_page?, [:show?, :new?, :edit?, :update?, :destroy?]

  def create?
    team_page? &&
      allow_nesting?
  end

  private

    def allow_nesting?
      page_depth <= ENV["NESTED_PAGE_LIMIT"].to_i
    end

    def page_depth
      return 1 unless page.parent
      page.parent.depth + 1
    end
end
