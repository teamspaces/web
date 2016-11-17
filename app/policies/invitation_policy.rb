class InvitationPolicy

  attr_reader :team_policy_context, :invitation

  def initialize(team_policy_context, invitation)
    @team_policy_context = team_policy_context
    @invitation = invitation
  end

  def associated?
    affiliated_to_user_team? && team_invitation?
  end

  private

    def affiliated_to_user_team?
      TeamPolicy.new(team_policy_context, invitation.team).associated?
    end

    def team_invitation?
      team_policy_context.team == invitation.team
    end
end
