require "test_helper"

describe User::CreateUserFromSlackIdentity, :model do

  subject { User::CreateUserFromSlackIdentity }

  before(:each) do
    stub_request(:get, "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg").
    to_return(status: 200, headers: {}, body: File.read("test/test_helpers/files/test_avatar_image.jpg"))
  end

  describe "#call" do
    it "creates user with authentication and avatar" do
      result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')
      assert result.success?

      assert_equal "maria@balvin.com", result.user.email
      assert_equal "Maria", result.user.first_name

      authentication = result.user.authentications.first
      assert authentication.uid
      assert_equal "slack", authentication.provider
      assert_equal "secret", authentication.token_secret

      assert result.user.avatar.present?
      assert UserAvatar.new(result.user).slack_avatar?
    end

    it "does not allow user to login with email" do
      result = subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user), token: 'secret')
      assert result.success?

      refute result.user.allow_email_login
    end
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
