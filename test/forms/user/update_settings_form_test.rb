require "test_helper"

describe User::UpdateSettingsForm, :model do
  subject { User::UpdateSettingsForm }
  let(:user) { users(:lars) }

  describe "validations" do
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

  describe "#save" do
    it "updates user attributes" do
      form = subject.new(user, last_name: "La Fuente")

      assert form.save
      assert_equal "La Fuente", user.last_name
    end

    describe "name changes" do
      let(:user_with_generated_avatar) do
        User::Avatar::AttachGeneratedAvatar.call(user: user)
        user
      end

      context "user has generated avatar" do
        it "updates avatar" do
          User::Avatar::AttachGeneratedAvatar.expects(:call)
                                             .with(user: user_with_generated_avatar)

          subject.new(user_with_generated_avatar, first_name: "Martinez").save
        end
      end
    end
  end
end
