require "test_helper"

describe SendTeamInvitation, :model do
  let(:invitation) { invitations(:jonas_at_furrow) }

  it "sends team mail-invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    result = SendTeamInvitation.call(invitation: invitation)
    assert result.success?
  end
end
