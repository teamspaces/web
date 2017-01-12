require "test_helper"

describe Shrine::AvatarUploader, :model do
  it "generates image thumbnails" do
    user = users(:lars)
    photo = User::UpdateSettingsForm.new(user, avatar: File.open("test/test_helpers/files/image.jpg"))
    photo.save
    user.reload
    debugger
    assert user.uploaded_avatar?
  end
end
