require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }
  let(:invitation) { invitations(:furrow) }

  it "generates token before creation" do
    invite = team.invitations.create(user: user, email: "n@web.com")
    assert invite.token
  end
end
