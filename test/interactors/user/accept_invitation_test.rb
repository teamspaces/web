require "test_helper"

describe User::AcceptInvitation, :model do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  subject { AcceptInvitation }

  context "valid token" do
    it "works" do
      assert subject.call(user: user, invitation: invitation).success?
    end

    it "adds user as team member" do
      assert_difference ->{ user.teams.count }, 1 do
        subject.call(user: user, invitation: invitation)
      end
    end

    it "destroys invitation" do
      assert_difference ->{ Invitation.count }, -1 do
        subject.call(user: user, invitation: invitation)
      end
    end
  end

  context "already member" do
    it "destroyes invitation" do
      assert_difference ->{ Invitation.count }, -1 do
        subject.call(user: invitation.team.users.first, invitation: invitation)
      end
    end
  end
end
