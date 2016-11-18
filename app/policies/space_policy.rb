class SpacePolicy
  extend AliasMethods

  attr_reader :default_context, :space

  def initialize(default_context, space)
    @default_context = default_context
    @space = space
  end

  def team_space?
    default_context.team == space.team
  end

  alias_methods :team_space?, [:show?, :new?, :edit?, :create?, :update?, :destroy?]
end
