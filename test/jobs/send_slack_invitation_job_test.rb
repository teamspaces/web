require "test_helper"

describe SendSlackInvitationJob, :model do
  subject { SendSlackInvitationJob }
  let(:invitation) { invitations(:slack_user_milad_invitation) }
  let(:user) { users(:lars) }

  it "sends invitation as slack message" do
    Invitation::SendSlackInvitation.expects(:call).with(invitation: invitation, user: user)

    subject.perform_now(invitation.id)
  end
end
