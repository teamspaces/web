class PagePolicy

  attr_reader :team_policy_context, :page

  def initialize(team_policy_context, page)
    @team_policy_context = team_policy_context
    @page = page
  end

  def associated?
    associated_to_team_space? && team_page?
  end

  private

    def associated_to_team_space?
      SpacePolicy.new(team_policy_context, page.space).associated?
    end

    def team_page?
      team_policy_context.team == page.team
    end
end
