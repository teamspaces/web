require "test_helper"

describe User::UpdateSettingsForm, :model do
  let(:user) { users(:lars) }
  subject { User::UpdateSettingsForm.new(user, {})}

  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)

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
    subject { User::UpdateSettingsForm }
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
                                             .returns(true)

          subject.new(user_with_generated_avatar, first_name: "Martinez").save
        end
      end
    end

    describe "email changes" do
      it "sends email confirmation mail" do
        User.any_instance.expects(:send_confirmation_instructions).once

        subject.new(user_with_generated_avatar, email: "que_pasa@nl.com").save
      end
    end
  end
end
