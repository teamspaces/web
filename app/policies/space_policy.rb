class SpacePolicy
  extend AliasMethods

  attr_reader :default_context, :team, :space

  def initialize(default_context, space)
    @default_context = default_context
    @team = default_context.team
    @space = space
  end

  def user_is_allowed_to_access_space?
    SpacePolicy::Scope.new(default_context, Space).resolve.exists?(space)
  end

  alias_methods :user_is_allowed_to_access_space?, [:show?, :new?, :edit?, :create?, :update?, :destroy?, :update_access_control?, :add_member?, :remove_member?]
end
