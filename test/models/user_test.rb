require 'test_helper'

describe User do
  let(:user) { users(:ulf) }

  should have_many(:authentications).dependent(:destroy)
  should have_many(:team_members).dependent(:destroy)
  should have_many(:teams).through(:team_members)

  should validate_presence_of(:password)
  should validate_presence_of(:email)

  describe "email validations" do
    let(:user_with_email_login) { users(:lars) }

    it "allows only one user to use email for email login" do
      another_user_with_email_login = User.new(email: user_with_email_login.email)

      refute another_user_with_email_login.save
      assert_includes another_user_with_email_login.errors.messages[:email], "has already been taken"
    end

    it "allows same email for users without email login" do
      user_with_same_email_attributes = { email: user_with_email_login.email,
                                          password: "secret",
                                          allow_email_login: false }

      another_user_without_email_login = User.new(user_with_same_email_attributes)
      assert another_user_without_email_login.save
      assert User.new(user_with_same_email_attributes).save
    end
  end

  describe "#name" do
    it "responds" do
      assert_equal "#{user.first_name} #{user.last_name}", user.name
    end
  end

  describe "#name=" do
    it "updates attributes" do
      user.name = "Lassie Chulo King"
      assert_equal "Lassie", user.first_name
      assert_equal "Chulo King", user.last_name
    end
  end

  describe "#find_for_authentication" do
    it "finds user that allows email login" do
      lars_email_login_allowed = users(:lars)
      lars_email_login_not_allowed = users(:lars_email_login_not_allowed)

      user_to_authenticate = User.find_for_authentication(email: lars_email_login_not_allowed.email)
      assert_equal lars_email_login_allowed, user_to_authenticate
    end
  end
end
