require "test_helper"

describe User::UpdateEmailForm, :model do
  let(:user) { users(:lars) }
  subject { User::UpdateEmailForm.new(user: user)}

  should validate_presence_of(:email)

  describe "validations" do
    it "validates email format" do
      form = User::UpdateEmailForm.new(user: user, attributes: { email: "non_valid" })

      form.valid?
      assert_includes form.errors[:email], "is invalid"
    end
  end

  describe "#save" do
    it "updates user email" do
      User::UpdateEmailForm.new(user: user, attributes: { email: "kiew@gmail.com" }).save

      user.reload
      assert_equal "kiew@gmail.com", user.unconfirmed_email
    end
  end
end
