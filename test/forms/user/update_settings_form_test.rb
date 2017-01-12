require "test_helper"

describe User::UpdateSettingsForm, :model do
  let(:user) { users(:lars) }

  describe "validations" do
    subject { User::UpdateSettingsForm }

    describe "password" do
      it "validates presence" do
        form = subject.new(user, password: "", password_confirmation: "")
        form.valid?

        assert_includes form.errors[:password], "can't be blank"
      end

      it "validates confirmation" do
        form = subject.new(user, password: "dos", password_confirmation: "uno")

        form.valid?
        assert_includes form.errors[:password_confirmation], "doesn't match Password"
      end
    end

    describe "first_name" do
      it "validates presence" do
        form = subject.new(user, first_name: "")
        form.valid?

        assert_includes form.errors[:first_name], "can't be blank"
      end
    end

    describe "last_name" do
      it "validates presence" do
        form = subject.new(user, last_name: "")
        form.valid?

        assert_includes form.errors[:last_name], "can't be blank"
      end
    end

    describe "email" do
      it "validates presence" do
        form = subject.new(user, email: "")
        form.valid?

        assert_includes form.errors[:email], "can't be blank"
      end

      it "validates format" do
        form = subject.new(user, email: "non_valid")

        form.valid?
        assert_includes form.errors[:email], "is invalid"
      end
    end
  end
end
