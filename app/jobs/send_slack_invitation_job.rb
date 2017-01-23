class SendSlackInvitationJob < ActiveJob::Base

  def perform(invitation_id)
    invitation = Invitation.find_by(id: invitation_id)
    return unless invitation;

    Invitation::SendSlackInvitation.call(invitation: invitation)
  end
end
