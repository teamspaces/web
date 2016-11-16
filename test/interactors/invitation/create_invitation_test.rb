require "test_helper"

describe Invitation::CreateInvitation, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:service) { Invitation::CreateInvitation }

  it "creates invitation" do
    result = service.call(invitation_params: { email: "ken@o.es" },
                          team: team, user: user)

    assert result.success?
    assert_equal user, result.invitation.user
    assert_equal team, result.invitation.team
  end

  context "invalid params" do
    it "does not create invitation" do
      result = service.call(invitation_params: { email: "invalid" },
                            team: team, user: user)

      refute result.success?
      assert result.invitation.errors[:email]
    end
  end
end
