require "test_helper"

describe User::CreateUserFromSlackIdentity, :model do

  subject { User::CreateUserFromSlackIdentity }

  describe "#call" do
    it "creates user with authentication" do
      result = subject.call(slack_identity: Slack::Identity::New.new, token: 'secret')
      assert result.success?

      assert_equal "maria@balvin.com", result.user.email
      assert_equal "Maria", result.user.first_name

      authentication = result.user.authentications.first
      assert_equal "slack", authentication.provider
      assert_equal "secret", authentication.token_secret
    end
  end

  describe "#rollback" do
    it "destroys created user" do
      result = subject.call(slack_identity: Slack::Identity::New.new, token: 'secret')

      assert_difference -> { User.count }, -1 do
        result.rollback!
      end
    end
  end
end
