require "test_helper"

describe RegisterWithInvitationForm, :model do
  let(:invitation) { invitations(:sven_at_power_rangers) }
  subject do
    RegisterWithInvitationForm.new(email: invitation.email, password: 'password', password_confirmation: 'password',
                                   invitation_token: invitation.token)
  end

  describe "validations" do
    it "validates user object" do
      subject.password_confirmation = "wrong_confirmation"
      subject.save
      assert_includes subject.errors[:password_confirmation], "doesn't match Password"

      subject.user.email = "wrong_format"
      subject.save
      assert_includes subject.errors[:email], "is invalid"
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

  it "saves user" do
    subject.save

    assert subject.user.persisted?
  end

  it "accepts invitation" do
    AcceptInvitation.expects(:call).with(user: subject.user, invitation: subject.invitation)

    subject.save
  end
end
