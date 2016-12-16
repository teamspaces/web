class Invitation::SendInvitation
  include Interactor

  def call
    invitation = context.invitation.decorate

    SendEmailInvitationJob.perform_later(invitation.id) if invitation.email_invitation?
    SendSlackInvitationJob.perform_later(invitation.id) if invitation.slack_invitation?
  end
end
