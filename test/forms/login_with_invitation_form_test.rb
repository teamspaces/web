require "test_helper"

describe LoginWithInvitationForm, :model do
  let(:user) { users(:without_team) }
  let(:invitation) { invitations(:katharina_at_power_rangers) }
  subject { LoginWithInvitationForm.new(email: user.email, password: 'password', invitation_token: invitation.token) }

  describe "validations" do
    should validate_presence_of(:email)
    should validate_presence_of(:password)

    it "validates email password combination" do
      subject.password = "wrong"
      subject.save

      assert_includes subject.errors[:base], "Invalid email or password."
    end

    it "validates presence of invitation" do
      subject.invitation_token = "wrong_token"
      subject.save

      assert_includes subject.errors[:invitation], "can't be blank"
    end

    it "validates user invitation affiliation" do
      subject.user.email = "wrong"
      subject.save

      assert_includes subject.errors[:email], "doesn't match invited email"
    end
  end

  it "accepts invitation" do
    AcceptInvitation.expects(:call).with(user: subject.user, invitation: subject.invitation)

    subject.user.email = subject.invitation.email
    subject.save
  end
end
