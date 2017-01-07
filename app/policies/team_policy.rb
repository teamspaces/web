class TeamPolicy
  extend AliasMethods

  attr_reader :user, :team

  def initialize(default_context, team)
    @user = default_context.user
    @team = team
  end

  def user_team_member?
    user.teams.where(id: team.id).exists?
  end

   alias_methods :user_team_member?, [:access?, :read?, :show?, :new?, :edit?, :create?, :update?, :destroy?]
end
