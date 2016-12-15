require "test_helper"

describe LoginRegisterFunnel::EmailAddressForm, :model do
  subject { LoginRegisterFunnel::EmailAddressForm.new }

  describe "validations" do
    should validate_presence_of(:email)

    describe "format of email" do
      subject { LoginRegisterFunnel::EmailAddressForm }

      context "valid" do
        it "works" do
          form = subject.new(email: "valid@email.com")

          assert form.valid?
        end
      end

      context "invalid" do
        it "includes error message" do
          form = subject.new(email: "invalid_email.com")

          refute form.valid?
          assert_includes form.errors[:email], "is invalid"
        end
      end
    end
  end
end
