class SendSlackInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(invitation_id)
    invitation = Invitation.find_by(id: invitation_id)
    return unless invitation;

    SendSlackInvitation.call(invitation: invitation)
  end

end
