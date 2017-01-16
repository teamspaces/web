require "test_helper"

describe User::Avatar::AttachSlackAvatar, :model do
  let(:user) { users(:lars) }

  before(:each) do
    stub_request(:get, "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg").
    to_return(status: 200, headers: {}, body: File.read("test/test_helpers/files/test_avatar_image.jpg"))
  end

  it "attaches slack avatar" do
    User::Avatar::AttachSlackAvatar.call(user: user, slack_identity: TestHelpers::Slack.identity(:unknown_user))

    assert user.save
    assert user.avatar.present?
    assert UserAvatar.new(user).slack_avatar?
  end
end
