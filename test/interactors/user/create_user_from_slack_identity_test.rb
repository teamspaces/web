require "test_helper"

describe User::CreateUserFromSlackIdentity, :model do

  subject { User::CreateUserFromSlackIdentity }
  let(:attach_slack_avatar_mock) do
    avatar_mock = mock
    avatar_mock.stubs(:success?).returns(true)
    avatar_mock.stubs(:failure?).returns(false)
    avatar_mock
  end
  before(:each) do
    User::Avatar::AttachSlackAvatar.stubs(:call)
                                   .returns(attach_slack_avatar_mock)
  end

  describe "#call" do
    it "creates user with authentication and avatar" do
      User::Avatar::AttachSlackAvatar.expects(:call)
                                     .returns(attach_slack_avatar_mock)

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
end
