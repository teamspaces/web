class TeamPolicy
  include AliasMethods

  attr_reader :default_context, :team

  def initialize(default_context, team)
    @default_context = default_context
    @team = team
  end

  alias_methods :user_team_member?, [:read?, :show?, :new?, :edit?, :create?, :update?, :destroy?]

  def user_team_member?
    default_context.user.teams.where(id: team.id).exists?
  end
end
