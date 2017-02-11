class SpacePolicy
  extend AliasMethods

  attr_reader :default_context, :team, :space

  def initialize(default_context, space)
    @default_context = default_context
    @team = default_context.team
    @space = space
  end

  def team_space?
    team == space.team
  end

  alias_methods :team_space?, [:new?, :create?]

  def user_is_allowed_to_access_space?
    SpacePolicy::Scope.new(default_context, Space).resolve.exists?(space.id)
  end

  alias_methods :user_is_allowed_to_access_space?, [:show?, :edit?, :update?, :destroy?, :update_access_control?]

  def private_space_that_user_is_allowed_to_access?
    user_is_allowed_to_access_space? && team.private_access_control_rule?
  end

  alias_methods :private_space_that_user_is_allowed_to_access? [:add_member?, :remove_member?]
end
