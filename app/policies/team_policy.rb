class TeamPolicy

  attr_reader :default_context, :team

  def initialize(default_context, team)
    @default_context = default_context
    @team = team
  end

  def user_team_member?
    default_context.team == team
  end

  [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |alt|
    alias_method alt, :user_team_member?
  end
end
