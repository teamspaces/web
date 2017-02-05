class SpaceMemberPolicy
  extend AliasMethods

  attr_reader :team, :user, :space_member

  def initialize(default_context, space_member)
    @team = default_context.team
    @user = default_context.user
    @space_member = space_member
  end

  def create?
    true
  end

  def destroy?
    true
  end
end
