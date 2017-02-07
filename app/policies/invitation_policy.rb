class InvitationPolicy
  attr_reader :team, :invitation

  def initialize(default_context, invitation)
    @team = default_context.team
    @invitation = invitation
  end

  def destroy?
    owned_by_team? && !invitation.used?
  end

  def send?
    owned_by_team?
  end

  private

    def owned_by_team?
      team == invitation.team
    end
end
