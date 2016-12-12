require "test_helper"

describe SendEmailInvitationJob, :model do
  let(:invitation) { invitations(:jonas_at_furrow) }

  it "sends team mail-invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    SendEmailInvitationJob.perform_now(invitation.id)
  end
end
