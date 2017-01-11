require "test_helper"

describe User::CreateUserFromSlackIdentity, :model do

  subject { User::CreateUserFromSlackIdentity }

  describe "#call" do
    it "creates user with authentication" do
      result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')
      assert result.success?

      assert_equal "maria@balvin.com", result.user.email
      assert_equal "Maria", result.user.first_name

      authentication = result.user.authentications.first
      assert authentication.uid
      assert_equal "slack", authentication.provider
      assert_equal "secret", authentication.token_secret
    end

    it "does not allow user to login with email" do
      result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')
      assert result.success?

      refute result.user.allow_email_login
    end
  end

  it "saves avatar" do
    result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')

    assert_equal "slack", result.user.avatar.metadata["source"]

    assert result.user.slack_avatar?
  end

  describe "#rollback" do
    it "destroys created user" do
      result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')

      assert_difference -> { User.count }, -1 do
        result.rollback!
      end
    end
  end
end
