class PagePolicy
  extend AliasMethods

  attr_reader :default_context, :user, :team, :space, :page

  def initialize(default_context, page)
    @default_context = default_context
    @user = default_context.user
    @team = default_context.team
    @space = page.space

    @page = page
  end

  def team_page?
    team == page.team && user_is_allowed_to_access_space?
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

    def user_is_allowed_to_access_space?
      SpacePolicy::Scope.new(default_context, Space).resolve.exists?(space.id)
    end
end
