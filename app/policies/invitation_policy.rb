class InvitationPolicy

  attr_reader :default_context, :invitation

  def initialize(default_context, invitation)
    @default_context = default_context
    @invitation = invitation
  end

  def destroy?
    owned_by_team?
  end

  private

    def owned_by_team?
      default_context.team == invitation.team
    end
end
