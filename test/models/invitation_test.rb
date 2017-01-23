require "test_helper"

describe Invitation do
  let(:team) { teams(:spaces) }
  let(:user)  { users(:lars) }

  should belong_to(:team)
  should belong_to(:user)
  should have_one(:invitee).class_name("User")

  should validate_uniqueness_of(:token)

  describe "#create" do
    it "generates token" do
      invitation = team.invitations.create(user: user, email: "n@web.com")
      assert invitation.token
    end
  end

  describe "scopes" do
    let(:unused_invitation) { invitations(:slack_user_milad_invitation) }
    let(:used_invitation) { invitations(:accepted_invitation) }

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

    let(:email_invitation) { invitations(:katharina_at_power_rangers).decorate }
  let(:slack_invitation) { invitations(:slack_user_milad_invitation).decorate }
  let(:accepted_invitation) { invitations(:accepted_invitation).decorate }

  describe "#slack_invitation?" do
    describe "slack_invitation" do
      it "returns true" do
        assert_equal true, slack_invitation.slack_invitation?
      end
    end

    describe "email_invitation" do
      it "returns false" do
        assert_equal false, email_invitation.slack_invitation?
      end
    end
  end

  describe "#email_invitation?" do
    describe "email_invitation" do
      it "returns true" do
        assert_equal true, email_invitation.email_invitation?
      end
    end

    describe "slack_invitation" do
      it "returns false" do
        assert_equal false, slack_invitation.email_invitation?
      end
    end
  end

  describe "#already_accepted?" do
    describe "accepted invitation" do
      it "returns true" do
        assert_equal true, accepted_invitation.already_accepted?
      end
    end

    describe "open invitation" do
      it "returns false" do
        assert_equal false, email_invitation.already_accepted?
      end
    end
  end

  describe "#accepting_user_is_already_registered_using_email?" do
    describe "accepting user is already registered using email" do
      it "returns true" do
        assert_equal true, email_invitation.accepting_user_is_already_registered_using_email?
      end
    end

    describe "accepting user is not yet registered using email" do
      it "returns false" do
        assert_equal false, slack_invitation.accepting_user_is_already_registered_using_email?
      end
    end
  end
end
