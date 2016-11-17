class InvitationPolicy

  attr_reader :default_context, :invitation

  def initialize(default_context, invitation)
    @default_context = default_context
    @invitation = invitation
  end

  def destroy?
    team_invitation?
  end

  private

    def team_invitation?
      default_context.team == invitation.team
    end
end
