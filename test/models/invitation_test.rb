require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }

  should belong_to(:team)
  should belong_to(:user)
  should have_one(:invitee).with_foreign_key("invitee_user_id")
                           .class_name("User")

  should validate_uniqueness_of(:token)

  describe "#create" do
    it "generates token" do
      invitation = team.invitations.create(user: user, email: "n@web.com")
      assert invitation.token
    end
  end
end
