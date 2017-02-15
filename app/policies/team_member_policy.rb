class TeamMemberPolicy
  extend AliasMethods

  attr_reader :team, :user, :team_member

  def initialize(default_context, team_member)
    @team = default_context.team
    @user = default_context.user

    @team_member = team_member
  end

  def destroy?
    my_team? &&
    !my_team_member? &&
    !team_member.primary_owner?
  end

  private

    def my_team_member?
      user == team_member.user
    end

    def my_team?
      team == team_member.team
    end
end
