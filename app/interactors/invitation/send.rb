class Invitation::Send
  include Interactor

  def call
    invitation = context.invitation

    SendEmailInvitationJob.perform_later(invitation.id) if invitation.email.present?
    SendSlackInvitationJob.perform_later(invitation.id) if invitation.slack_invitation?
  end
end
