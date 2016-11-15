require "test_helper"

describe Invitation do
  let(:team) { teams(:furrow) }
  let(:user)  { users(:lars) }

  describe "validations" do
    it "validates presence of team" do
      invitation = Invitation.create(user: user, email: "em@is.de")
      assert_includes invitation.errors[:team], "must exist"
    end

    it "validates presence of user" do
      invitation = Invitation.create(team: team, email: "em@is.de")
      assert_includes invitation.errors[:user], "must exist"
    end

    it "validates format of email" do
      invitation = team.invitations.create(email: "wrongformat")
      assert_includes invitation.errors[:email], "is invalid"
    end

    it "validates presence of email" do
      invitation = team.invitations.create(email: nil, user: user)
      assert_includes invitation.errors[:email], "is invalid"
    end

    it "validates email only one invitation for team" do
      invite_same_email = team.invitations.create(invitations(:furrow).attributes)
      email_errors = invite_same_email.errors[:email]
      assert_includes email_errors, "already has invitation for team"
    end
  end

  it "generates token before creation" do
    invite = team.invitations.create(user: user, email: "n@web.com")
    assert invite.token
  end

  describe "sends invitation after creation" do
    it "sends join team email invitation" do
      invitation = team.invitations.new(email: "new_sarah@es.com", user: user)
      InvitationMailer.expects(:join_team).with(invitation).returns(email_mock = mock)
      email_mock.expects(:deliver)
      invitation.save
    end
  end
end
