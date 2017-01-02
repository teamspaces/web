require 'test_helper'

describe User do
  let(:user) { users(:ulf) }

  should have_many(:authentications).dependent(:destroy)
  should have_many(:team_members).dependent(:destroy)
  should have_many(:teams).through(:team_members)

  should validate_presence_of(:password)
  should validate_presence_of(:email)

  describe "email uniqueness validations" do

    context "email users with same email" do
      it "is invalid" do
        email_user = users(:lars)
        email_user_with_same_email = User.create(email: email_user.email,
                                                 allow_email_login: true)

        assert_includes email_user_with_same_email.errors.messages[:email], "has already been taken"
      end
    end

    context "slack users with same email" do
      it "is valid" do
        slack_user = users(:slack_user_milad)
        slack_user_with_same_email = User.create(email: slack_user.email,
                                                 allow_email_login: false)

        assert_empty slack_user_with_same_email.errors.messages[:email]
      end
    end

    context "slack and email user with same email" do
      it "is valid" do
        slack_user = users(:slack_user_milad)
        email_user_with_same_email = User.create(email: slack_user.email,
                                                 allow_email_login: true)

        assert_empty email_user_with_same_email.errors.messages[:email]
      end
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
