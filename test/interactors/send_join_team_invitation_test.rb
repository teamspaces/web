require "test_helper"

describe SendJoinTeamInvitation, :model do
  let(:invitation) { invitations(:jonas_at_furrow) }

  it "sends join team mail-invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    result = SendJoinTeamInvitation.call(invitation: invitation)
    assert result.success?
  end
end
