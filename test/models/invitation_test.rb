require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }

  it "generates token before creation" do
    invitation = team.invitations.create(user: user, email: "n@web.com")
    assert invitation.token
  end
end
