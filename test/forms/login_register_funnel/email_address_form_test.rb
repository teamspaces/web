require "test_helper"

describe LoginRegisterFunnel::EmailAddressForm, :model do
  subject { LoginRegisterFunnel::EmailAddressForm.new }

  describe "validations" do
    should validate_presence_of(:email)

    describe "format of email" do
      subject { LoginRegisterFunnel::EmailAddressForm }

      context "valid" do
        it "works" do
          subject.new(email: "valid@email.com")

          assert subject.valid?
        end
      end

      context "invalid" do
        it "includes error message" do
          subject.new(email: "invalid_email.com")

          refute subject.valid?
          assert_includes subject.errors[:email], "is invalid"
        end
      end
    end
  end
end
