require "test_helper"

describe LoginRegisterFunnel::EmailLoginForm, :model do
  subject { LoginRegisterFunnel::EmailLoginForm.new }

  describe "validations" do
    should validate_presence_of(:email)
    should validate_presence_of(:password)

    describe "email/password combination" do
      subject { LoginRegisterFunnel::EmailLoginForm }
      let(:email_user) { users(:without_team) }

      context "valid" do
        it { assert subject.new(email: email_user.email, password: "password").valid? }
      end

      context "invalid" do
        it "includes error message" do
          form = subject.new(email: email_user.email, password: "wrong")

          refute form.valid?
          assert_includes form.errors.full_messages, "Password doesn't match email address"
        end
      end
    end
  end
end
