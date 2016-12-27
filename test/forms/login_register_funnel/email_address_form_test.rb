require "test_helper"

describe LoginRegisterFunnel::EmailAddressForm, :model do
  subject { LoginRegisterFunnel::EmailAddressForm.new }

  describe "validations" do
    should validate_presence_of(:email)

    describe "format of email" do
      subject { LoginRegisterFunnel::EmailAddressForm }

      context "valid email" do
        it "is valid" do
          assert subject.new(email: "valid@email.com").valid?
        end
      end

      context "invalid email" do
        it "is not valid, includes error message" do
          form = subject.new(email: "invalid_email.com")

          refute form.valid?
          assert_includes form.errors[:email], "is invalid"
        end
      end
    end
  end
end
