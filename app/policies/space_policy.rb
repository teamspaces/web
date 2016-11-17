class SpacePolicy

  attr_reader :team_policy_context, :space

  def initialize(team_policy_context, space)
    @team_policy_context = team_policy_context
    @space = space
  end

  def associated?
   associated_to_user_team? && team_space?
  end

  private

    def associated_to_user_team?
      TeamPolicy.new(team_policy_context, space.team).associated?
    end

    def team_space?
      team_policy_context.team == space.team
    end
end
