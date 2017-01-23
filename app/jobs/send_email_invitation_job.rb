class SendEmailInvitationJob < ActiveJob::Base

  def perform(invitation_id, user_id)
    invitation = Invitation.find_by(id: invitation_id)
    user = User.find_by(id: user_id)
    return unless invitation && user;

    InvitationMailer.join_team(invitation, user).deliver_later
  end
end
