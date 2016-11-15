require "test_helper"

describe Invitation::CreateAndSendJoinTeamInviteMail, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:service) { Invitation::CreateAndSendJoinTeamInviteMail }

  it "creates invitation" do
    success, invitation = service.call({ email: "ken@o.es" }, team, user)

    assert success
    assert_equal user, invitation.user
    assert_equal team, invitation.team
  end

  it "sends join team mail-invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    service.call({ email: "kay@o.es" }, team, user)
  end

  context "invalid params" do
    it "does not create invitation" do
      success, invitation = service.call({ email: "invalid" }, team, user)

      refute success
      assert invitation.errors[:email]
    end
  end
end
