class Invitation::SendInvitation
  include Interactor

  def call
    invitation = context.invitation.decorate
    user = context.user

    SendEmailInvitationJob.perform_later(invitation.id, user.id) if invitation.email.present?
    SendSlackInvitationJob.perform_later(invitation.id, user.id) if invitation.slack_invitation?
  end
end
