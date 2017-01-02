require "test_helper"

describe User::AcceptInvitation, :model do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  subject { User::AcceptInvitation }

  context "valid token" do
    it "works" do
      assert subject.call(user: user, invitation: invitation).success?
    end

    it "adds user as team member" do
      assert_difference ->{ user.teams.count }, 1 do
        subject.call(user: user, invitation: invitation)
      end
    end

    it "saves user as invitee " do
      subject.call(user: user, invitation: invitation)

      invitation.reload
      assert_equal user, invitation.invitee
    end
  end
end
