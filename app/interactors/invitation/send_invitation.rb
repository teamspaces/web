class Invitation::SendInvitation
  include Interactor

  def call
    invitation = context.invitation

    SendEmailInvitationJob.perform_later(invitation.id) if invitation.email
    SendSlackInvitationJob.perform_later(invitation.id) if invitation.slack_user_id
  end
end
