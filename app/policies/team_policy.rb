class TeamPolicy

  attr_reader :team_policy_context, :team

  def initialize(team_policy_context, team)
    @team_policy_context = team_policy_context
    @team = team
  end

  def associated?
    user_allowed_to_access_team?
  end

  private

    def user_allowed_to_access_team?
      team_policy_context.user.teams.where(id: team.id).exists?
    end
end
