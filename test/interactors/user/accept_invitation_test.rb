require "test_helper"

describe User::AcceptInvitation, :model do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  let(:space_invitation) { invitations(:space_invitation) }
  subject { User::AcceptInvitation }

  context "valid token" do
    it "works" do
      assert subject.call(invited_user: user, invitation: invitation).success?
    end

    it "adds user as team member" do
      assert_difference ->{ user.teams.count }, 1 do
        subject.call(invited_user: user, invitation: invitation)
      end
    end

    it "saves user as invited user" do
      subject.call(invited_user: user, invitation: invitation)

      invitation.reload
      assert_equal user, invitation.invited_user
    end

    context "space invitation" do
      it "adds invited user to space members" do
        assert_difference -> { space_invitation.space.space_members.count }, 1 do
          subject.call(invited_user: user, invitation: space_invitation)
        end
      end
    end

    context "is email invitation" do
      it "confirms invited user's email" do
        subject.call(invited_user: user, invitation: invitation)

        assert user.confirmed?
      end
    end
  end
end
