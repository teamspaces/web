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
          assert_includes subject.errors[:email], "no associated account was found"
        end
      end

      context "slack user with email exists" do
        it "is invalid" do
          subject.email = slack_user.email

          refute subject.valid?
          assert_includes subject.errors[:email], "belongs to an account with that you can sign in without providing a password.\nPlease try to sign in again with this email, you will get further options.\n"
        end
      end
    end
  end

  describe "#send_reset_password_instructions" do
    it "sends password reset instructions to user" do
      User.any_instance.expects(:send_reset_password_instructions)

      subject.email = email_user.email
      subject.send_reset_password_instructions
    end
  end
end
