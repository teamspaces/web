require "test_helper"

describe SendInvitationForm, :model do
  let(:existing_invitation) { invitations(:jonas_at_furrow) }
  subject { SendInvitationForm.new(user: users(:lars), team: teams(:furrow)) }

  describe "validations" do
    should validate_presence_of(:team)
    should validate_presence_of(:user)
    should validate_presence_of(:email)

    it "validates format of email" do
      subject.email = "invalid_format"
      subject.save
      assert_includes subject.errors[:email], "is invalid"
    end

    it "validates email only one invitation for team" do
      subject.team = existing_invitation.team
      subject.email = existing_invitation.email
      subject.save
      assert_includes subject.errors[:email], "already has invitation for team"
    end
  end

  it "sends email-invitation" do
    SendTeamInvitation.expects(:call)

    subject.email = "gu@es.de"
    subject.save
  end
end
