class SpacePolicy

  attr_reader :default_context, :space

  def initialize(default_context, space)
    @default_context = default_context
    @space = space
  end

  def team_space?
    default_context.team == space.team
  end

  [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |alt|
    alias_method alt, :team_space?
  end
end
