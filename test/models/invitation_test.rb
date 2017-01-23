require "test_helper"

describe Invitation do
  let(:team) { teams(:spaces) }
  let(:user)  { users(:lars) }

  should belong_to(:team)
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
end
