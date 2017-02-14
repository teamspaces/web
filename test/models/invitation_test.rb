require "test_helper"

describe Invitation do
  let(:team) { teams(:spaces) }
  let(:user)  { users(:lars) }

  let(:email_invitation) { invitations(:katharina_at_power_rangers) }
  let(:slack_invitation) { invitations(:slack_user_milad_invitation) }
  let(:used_invitation) { invitations(:used_invitation) }
  let(:unused_invitation) { slack_invitation }
  let(:team_invitation) { email_invitation }
  let(:space_invitation) { invitations(:space_invitation) }

  should belong_to(:team)
  should belong_to(:invited_by_user).class_name("User")
  should belong_to(:invited_user).class_name("User")

  should validate_uniqueness_of(:token)

  describe "#create" do
    it "generates token" do
      invitation = team.invitations.create(invited_by_user: user, email: "n@web.com")
      assert invitation.token
    end
  end

  describe "scopes" do
    describe "#used" do
      it "works" do
        used_invitations = Invitation.used

        assert_includes used_invitations, used_invitation
        assert_not_includes used_invitations, unused_invitation
      end
    end

    describe "#unused" do
      it "works" do
        unused_invitations = Invitation.unused

        assert_includes unused_invitations, unused_invitation
        assert_not_includes unused_invitations, used_invitation
      end
    end
  end

  describe "#slack_invitation?" do
    context "slack_invitation" do
      it "returns true" do
        assert slack_invitation.slack_invitation?
      end
    end

    context "email_invitation" do
      it "returns false" do
        refute email_invitation.slack_invitation?
      end
    end
  end

  describe "#email_invitation?" do
    context "email_invitation" do
      it "returns true" do
        assert email_invitation.email_invitation?
      end
    end

    context "slack_invitation" do
      it "returns false" do
        refute slack_invitation.email_invitation?
      end
    end
  end

  describe "space_invitation?" do
    context "space invitation" do
      it "returns true" do
        assert space_invitation.space_invitation?
      end
    end

    context "team invitation" do
      it "returns false" do
        refute team_invitation.space_invitation?
      end
    end
  end

  describe "#used?" do
    context "used invitation" do
      it "returns true" do
        assert used_invitation.used?
      end
    end

    context "not used invitation" do
      it "returns false" do
        refute email_invitation.used?
      end
    end
  end

  describe "#invited_user_is_registered_email_user?" do
    context "invited user is registered email user" do
      it "returns true" do
        assert email_invitation.invited_user_is_registered_email_user?
      end
    end

    context "invited user is not registered email user" do
      it "returns false" do
        refute slack_invitation.invited_user_is_registered_email_user?
      end
    end
  end
end
