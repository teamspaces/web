class TeamPolicy::Scope
  attr_reader :user, :scope

  def initialize(default_context, scope)
    @user = default_context.user
    @scope = scope
  end

  def resolve
    scope.joins(:members).where(team_members: { user_id: user.id })
  end
end
