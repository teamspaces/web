require "test_helper"

describe SendInvitationForm, :model do
  let(:invitation) { invitations(:furrow) }
  subject { SendInvitationForm.new(invitation.attributes) }

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
      subject.team = invitation.team
      subject.email = invitation.email
      subject.save
      assert_includes subject.errors[:email], "already has invitation for team"
    end
  end

  it "calls email-invitation interactor" do
    SendJoinTeamInvitation.expects(:call)

    invitation_form = SendInvitationForm.new(user: users(:lars), team: teams(:furrow))
    invitation_form.email = "gu@es.de"
    invitation_form.save
  end
end
