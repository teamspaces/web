require "test_helper"

describe SendEmailInvitationJob, :model do
  subject { SendEmailInvitationJob }
  let(:invitation) { invitations(:jonas_at_spaces) }

  it "sends invitation as email" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    subject.perform_now(invitation.id)
  end
end
