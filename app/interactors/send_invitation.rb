class SendInvitation
  include Interactor

  def call
    invitation = context.invitation

    InvitationMailer.join_team(invitation).deliver_later if invitation.email
    SendSlackInvitationJob.perform_later(invitation.id) if invitation.slack_user_id
  end
end
