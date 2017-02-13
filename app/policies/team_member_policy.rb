class TeamMemberPolicy
  extend AliasMethods

  attr_reader :team, :user, :team_member

  def initialize(default_context, team_member)
    @team = default_context.team
    @user = default_context.user

    @team_member = team_member
  end

  def destroy?
    team_team_member? &&
    !user_remove_itself? &&
    !team_member.primary_owner?
  end

  private

    def user_remove_itself?
      user == team_member.user
    end

    def team_team_member?
      team == team_member.team
    end
end
