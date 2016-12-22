require "test_helper"

describe LoginRegisterFunnel::EmailRegisterForm, :model do
  subject { LoginRegisterFunnel::EmailRegisterForm.new }

  describe "validations" do
    should validate_presence_of(:email)
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:password)
    should validate_presence_of(:password_confirmation)

    describe "password" do
      subject { LoginRegisterFunnel::EmailRegisterForm }

      it "validates confirmation" do
        form = subject.new(password: "dos", password_confirmation: "uno")

        form.valid?
        assert_includes form.errors[:password_confirmation], "doesn't match Password"
      end
    end

    describe "email" do
      subject { LoginRegisterFunnel::EmailRegisterForm }

      it "validates format of email" do
        form = subject.new(email: "non_valid")

        form.valid?
        assert_includes form.errors[:email], "is invalid"
      end
    end
  end

  describe "#save" do
    subject do
      LoginRegisterFunnel::EmailRegisterForm.new({
        email: "air@spaces.is",
        first_name: "Verena",
        last_name: "Sturm",
        password: "password",
        password_confirmation: "password"
      })
    end

    it "creates user" do
      assert_difference -> { User.count }, 1 do
        subject.save
      end
    end
  end
end
