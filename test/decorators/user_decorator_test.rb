require "test_helper"

describe UserDecorator, :model do
  let(:email_user) { users(:sven).decorate }
  let(:slack_user) { users(:slack_user_milad).decorate }

  describe "#login_using_email?" do
    context "email user" do
      it "is true" do
        assert email_user.login_using_email?
      end
    end
    context "slack user" do
      it "refutes" do
        refute slack_user.login_using_email?
      end
    end
  end

  describe "#login_using_slack?" do
    context "slack user" do
      it "is true" do
        assert slack_user.login_using_slack?
      end
    end
    context "email user" do
      it "refutes" do
        refute email_user.login_using_slack?
      end
    end
  end
end
