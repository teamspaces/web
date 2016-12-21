require "test_helper"

describe UserDecorator, :model do
  let(:email_user) { users(:sven).decorate }
  let(:slack_user) { users(:slack_user_milad).decorate }

  describe "#login_using_email?" do
    context "email user" do
      it { assert email_user.login_using_email? }
    end
    context "slack user" do
      it { refute slack_user.login_using_email? }
    end
  end

  describe "#login_using_slack?" do
    context "slack user" do
      it { assert slack_user.login_using_slack? }
    end
    context "email user" do
      it { refute email_user.login_using_slack? }
    end
  end
end
