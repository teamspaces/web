require "test_helper"

describe Shrine::AvatarUploader, :model do
  let(:user) { users(:lars) }

  it "should process avatar" do
    image = FakeIO.new(Avatarly.generate_avatar("E"))
    cached = Shrine::AvatarUploader.new(:cache).upload(image)
    uploader = Shrine::AvatarUploader.new(:store)
    processed = uploader.process(cached, phase: :store)

    assert processed[:medium].present?
    assert processed[:large].present?
    assert processed[:small].present?
    assert processed[:original].present?
  end

  describe "validations" do
    it "should validate size of avatar" do
      more_than_three_mb =  3.1*1024*1024
      image = FakeIO.new(Random.new.bytes(more_than_three_mb), filename: "image.jpg", content_type: "image/jpg")
      user.avatar = Shrine::AvatarUploader.new(:cache).upload(image)
      user.valid?

      assert_includes user.errors[:avatar], "is too large (max is 3.0 MB)"
    end

    it "should validate format of avatar" do
      pdf_file = FakeIO.new("file_content", filename: "pdf_file.pdf")
      user.avatar = Shrine::AvatarUploader.new(:cache).upload(pdf_file)
      user.valid?

      assert_includes user.errors[:avatar], "isn't of allowed type (allowed types: image/jpeg, image/jpg, image/png, image/gif)"
    end
  end
end
