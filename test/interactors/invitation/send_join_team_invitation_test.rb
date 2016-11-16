require "test_helper"

describe Invitation::SendJoinTeamInvitation, :model do
  let(:invitation) { invitations(:furrow) }

  it "sends join team mail-invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    result = Invitation::SendJoinTeamInvitation.call(invitation: invitation)
    assert result.success?
  end
end
