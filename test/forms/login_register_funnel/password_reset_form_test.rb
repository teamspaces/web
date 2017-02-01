require "test_helper"

describe LoginRegisterFunnel::PasswordResetForm, :model do
  subject { LoginRegisterFunnel::PasswordResetForm.new }

  let(:email_user) { users(:lars) }
  let(:slack_user) { users(:slack_user_emil) }

  describe "validations" do
    should validate_presence_of(:email)

    describe "no email user with that email" do
      context "no user with email exists" do
        it "is invalid" do
          subject.email = "invalid@eami"

          refute subject.valid?
          assert_includes subject.errors[:email], "no user found wsith that email"
        end
      end

      context "slack user with email exists" do
        it "is invalid" do
          subject.email = slack_user.email

          refute subject.valid?
          assert_includes subject.errors[:email], "please sign up swith ..."
        end
      end
    end
  end

  describe "#send_reset_password_instructions" do
    it "sends password reset instructions to user" do
      email_user.expects(:send_reset_password_instructions)

      subject.email = email_user.email
      assert subject.send_reset_password_instructions
    end
  end
end
