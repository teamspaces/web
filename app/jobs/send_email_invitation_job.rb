class SendEmailInvitationJob < ActiveJob::Base

  def perform(invitation_id, user_id)
    invitation = Invitation.find_by(id: invitation_id)
    return unless invitation;

    InvitationMailer.join_team(invitation).deliver_later
  end
end
