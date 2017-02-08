class SpaceFormPolicy
  extend AliasMethods

  attr_reader :team, :space_form

  def initialize(default_context, space_form)
    @team = default_context.team
    @space_form = space_form
  end

  def team_space?
    team == space_form.team
  end

  alias_methods :team_space?, [:new?, :edit?, :create?, :update?]
end
