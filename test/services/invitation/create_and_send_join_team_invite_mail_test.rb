require "test_helper"

describe Invitation::CreateAndSendJoinTeamInviteMail, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:service) { Invitation::CreateAndSendJoinTeamInviteMail }

  def team_params(email)
    { invitation: { email: email} }
  end

  it "creates invitation" do
    debugger
    success, invitation = service.call(team_params("ken@o.es"), team, user)

    assert success
    assert_equal user, invitation.user
    assert_equal team, invitation.team
  end

  it "sends join team email invitation" do
    InvitationMailer.expects(:join_team).returns(email_mock = mock)
    email_mock.expects(:deliver_later)

    service.call(team_params("kay@o.es"), team, user)
  end

  context "invalid params" do
    it "does not create invitation" do
       success, invitation = service.call(team_params("invalid"), team, user)

       refute success
       assert invitation.errors[:email]
    end
  end
end
