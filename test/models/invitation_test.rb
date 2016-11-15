require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }
  let(:invitation) { invitations(:furrow) }

  describe "validations" do
    it "validates presence of team" do
      invite = Invitation.create(user: user)
      assert_includes invite.errors[:team], "must exist"
    end

    it "validates presence of user" do
      invite = Invitation.create(team: team)
      assert_includes invite.errors[:user], "must exist"
    end

    it "validates format of email" do
      invite = team.invitations.create(email: "wrongformat")
      assert_includes invite.errors[:email], "is invalid"
    end

    it "validates presence of email" do
      invite = team.invitations.create(email: nil)
      assert_includes invite.errors[:email], "is invalid"
    end

    it "validates email only one invitation for team" do
      invite_same_email = team.invitations.create(invitation.attributes)
      email_errors = invite_same_email.errors[:email]
      assert_includes email_errors, "already has invitation for team"
    end
  end

  it "generates token before creation" do
    invite = team.invitations.create(user: user, email: "n@web.com")
    assert invite.token
  end
end
