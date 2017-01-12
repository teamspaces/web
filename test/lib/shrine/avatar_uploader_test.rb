require "test_helper"

describe Shrine::AvatarUploader, type: :model do
  image = File.open("test/test_helpers/files/image.jpeg")

  cached = Shrine::AvatarUploader.new(:cache).upload(image)


  it "should process images" do
    uploader = Shrine::AvatarUploader.new(:store)

    processed = uploader.process(cached, phase: :store)

    assert processed[:medium].present?
    assert processed[:large].present?
    assert processed[:small].present?
    assert processed[:original].present?
  end
end
