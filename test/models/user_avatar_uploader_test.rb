require "test_helper"

describe UserAvatarUploader, :model do
  let(:user) { users(:lars) }

  describe "background processing" do
    let(:avatar_versions_mock) do
      avatar_versions_mock = mock
      avatar_versions_mock.stubs(:versions).returns({})
      avatar_versions_mock
    end

    it "creates different versions of avatar" do
      image = FakeIO.new("img_content", filename: "image.png")
      cached = UserAvatarUploader.new(:cache).upload(image)
      uploader = UserAvatarUploader.new(:store)

      User::Avatar::VersionsGenerator.expects(:call)
                                     .with(io: cached)
                                     .returns(avatar_versions_mock)

      uploader.process(cached, phase: :store)
    end
  end

  describe "validations" do
    it "validates size of avatar" do
      more_than_three_mb =  3.1*1024*1024
      image = FakeIO.new(Random.new.bytes(more_than_three_mb), filename: "image.jpg", content_type: "image/jpg")
      user.avatar = UserAvatarUploader.new(:cache).upload(image)
      user.valid?

      assert_includes user.errors[:avatar], "is too large (max is 3.0 MB)"
    end

    it "validates format of avatar" do
      pdf_file = FakeIO.new("file_content", filename: "pdf_file.pdf")
      user.avatar = UserAvatarUploader.new(:cache).upload(pdf_file)
      user.valid?

      assert_includes user.errors[:avatar], "isn't of allowed type (allowed types: image/jpeg, image/jpg, image/png, image/gif)"
    end
  end
end
