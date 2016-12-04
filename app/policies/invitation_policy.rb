class InvitationPolicy
  attr_reader :team, :invitation

  def initialize(default_context, invitation)
    @team = default_context.team
    @invitation = invitation
  end

  def destroy?
    owned_by_team? && not_accepted?
  end

  private

    def owned_by_team?
      team == invitation.team
    end

    def not_accepted?
      invitation.invitee.nil?
    end
end
