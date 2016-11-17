class SendInvitationFormPolicy

  attr_reader :default_context, :send_invitation_form

  def initialize(default_context, send_invitation_form)
    @default_context = default_context
    @send_invitation_form = send_invitation_form
  end

  def create?
    team_invitation?
  end

  private

    def team_invitation?
      default_context.team == send_invitation_form.team
    end
end
