require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }

  should belong_to(:team)
  should belong_to(:user)
  should have_one(:invitee)

  should validate_uniqueness_of(:token)

  describe "#create" do
    it "generates token" do
      invitation = team.invitations.create(user: user, email: "n@web.com")
      assert invitation.token
    end
  end
end
