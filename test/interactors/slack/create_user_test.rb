require "test_helper"
require "slack_identites"

describe Slack::CreateUser, :model do
  include SlackIdentities

  subject { Slack::CreateUser }

  describe "#call" do
    it "creates user with authentication" do
      result = subject.call(slack_identity: new_slack_identity, token: 'secret')
      assert result.success?

      assert_equal "emmanuel@furrow.io", result.user.email
      assert_equal "Emmanuel", result.user.first_name

      authentication = result.user.authentications.first
      assert_equal "slack", authentication.provider
      assert_equal "secret", authentication.token_secret
    end
  end

  describe "#rollback" do
    it "destroys created user" do
      result = subject.call(slack_identity: new_slack_identity, token: 'secret')

      assert_difference -> { User.count }, -1 do
        result.rollback!
      end
    end
  end
end
