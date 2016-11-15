require "test_helper"

describe Invitation do
  let(:member)  { team_members(:lars_at_furrow) }

  describe "associations" do
    it "has one team through team_member" do
      invitation = Invitation.create(team_member: member, email: "barc@es.de")
      assert_equal member.team, invitation.team
    end
  end

  describe "validations" do
    it "validates format of email" do
      invitation = Invitation.create(email: "wrongformat", team_member: member)
      assert_includes invitation.errors[:email], "is invalid"
    end

    it "validates presence of email" do
      invitation = Invitation.create(email: nil, team_member: member)
      assert_includes invitation.errors[:email], "is invalid"
    end

    it "validates email only one invitation for team" do
      invite_same_email = Invitation.create(invitations(:furrow).attributes)
      email_errors = invite_same_email.errors[:email]
      assert_includes email_errors, "already has invitation for team"
    end
  end

  it "generates token before creation" do
    invite = Invitation.create(team_member: member, email: "n@web.com")
    assert invite.token
  end

  describe "sends invitation after creation" do
    it "sends join team email invitation" do
      invitation = Invitation.new(email: "new_sarah@es.com", team_member: member)
      InvitationMailer.expects(:join_team).with(invitation).returns(email_mock = mock)
      email_mock.expects(:deliver)
      invitation.save
    end
  end
end
