class SendSlackInvitationJob < ActiveJob::Base

  def perform(invitation_id, user_id)
    invitation = Invitation.find_by(id: invitation_id)
    user = User.find_by(id: user_id)
    return unless invitation && user;

    Invitation::SendSlackInvitation.call(invitation: invitation, user: user)
  end
end
