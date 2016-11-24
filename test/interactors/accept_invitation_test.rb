require "test_helper"

describe AcceptInvitation, :model do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:sven_at_power_rangers) }
  subject { AcceptInvitation }

  context "valid token" do
    it "works" do
      assert subject.call(user: user, token: invitation.token).success?
    end

    it "adds users as team member" do
      assert_difference ->{ user.teams.count }, 1 do
        subject.call(user: user, token: invitation.token)
      end
    end

    it "destroyes invitation" do
      assert_difference ->{ Invitation.count }, -1 do
        subject.call(user: user, token: invitation.token)
      end
    end
  end

  context "invalid token" do
    it "fails" do
      refute subject.call(user: user, token: "wrong").success?
    end
  end

  context "already member" do
    it "destroyes invitation" do
      assert_difference ->{ Invitation.count }, -1 do
        subject.call(user: invitation.team.users.first, token: invitation.token)
      end
    end
  end
end
