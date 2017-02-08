require "test_helper"

describe SendSlackInvitationJob, :model do
  subject { SendSlackInvitationJob }
  let(:invitation) { invitations(:slack_user_milad_invitation) }

  it "sends invitation as slack message" do
    Invitation::SlackInvitation::Send.expects(:call).with(invitation: invitation)

    subject.perform_now(invitation.id)
  end
end
