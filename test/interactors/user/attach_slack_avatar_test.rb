require "test_helper"

describe User::AttachSlackAvatar, :model do
  let(:user) { users(:lars) }

  it "assigns generated avatar" do
    User::AttachSlackAvatar.call(user: user, slack_identity: TestHelpers::Slack.identity(:unknown_user))

    assert user.save
    assert user.avatar.present?
    assert user.slack_avatar?
  end
end
