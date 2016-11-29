require 'test_helper'

describe User do
  let(:user) { users(:ulf) }

  should have_many(:authentications).dependent(:destroy)
  should have_many(:team_members).dependent(:destroy)
  should have_many(:teams).through(:team_members)


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
      debugger
      assert_equal lars_email_login_allowed, user_to_authenticate
    end
  end
end
