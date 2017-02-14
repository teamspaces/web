require "test_helper"

describe UserDecorator, :model do
  let(:email_user) { users(:sven).decorate }
  let(:slack_user) { users(:slack_user_milad).decorate }

  describe "#login_using_email?" do
    context "email user" do
      it "returns true" do
        assert_equal true, email_user.login_using_email?
      end
    end
    context "slack user" do
      it "returns false" do
        assert_equal false, slack_user.login_using_email?
      end
    end
  end

  describe "#login_using_slack?" do
    context "slack user" do
      it "returns true" do
        assert_equal true, slack_user.login_using_slack?
      end
    end
    context "email user" do
      it "returns false" do
        assert_equal false, email_user.login_using_slack?
      end
    end
  end

  describe "#auth_method" do
    context "email user" do
      it "returns email" do
        assert_equal "email", email_user.auth_method
      end
    end

    context "slack user" do
      it "returns slack" do
        assert_equal "slack", slack_user.auth_method
      end
    end
  end
end
