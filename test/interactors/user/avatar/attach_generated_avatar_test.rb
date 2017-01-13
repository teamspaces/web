require "test_helper"

describe User::Avatar::AttachGeneratedAvatar, :model do
  let(:user) { users(:lars) }

  it "assigns generated avatar" do
    User::Avatar::AttachGeneratedAvatar.call(user: user)

    assert user.save
    assert user.avatar.present?
    assert user.generated_avatar?
  end
end
