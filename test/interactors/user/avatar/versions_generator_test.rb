require "test_helper"

describe User::Avatar::VersionsGenerator, :model do

  describe "#call" do
    it "generates different avatar versions" do
      image = FakeIO.new(Avatarly.generate_avatar("E"))
      cached = Shrine::AvatarUploader.new(:cache).upload(image)

      versions = User::Avatar::VersionsGenerator.call(io: cached)

      assert versions[:medium].present?
      assert versions[:large].present?
      assert versions[:small].present?
      assert versions[:original].present?
    end
  end
end
