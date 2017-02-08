class SpacePolicy
  extend AliasMethods

  attr_reader :team, :space

  def initialize(default_context, space)
    @team = default_context.team
    @space = space
  end

  def team_space?
    team == space.team
  end

  alias_methods :team_space?, [:show?, :new?, :edit?, :create?, :update?, :destroy?, :update_access_control?, :add_member?, :remove_member?]
end
