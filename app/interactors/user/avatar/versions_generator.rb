class User::Avatar::VersionsGenerator
  include ImageProcessing::MiniMagick
  include Interactor

  def call
    @io = context.io

    context.versions = generate_versions
  end

  def generate_versions
    original = @io.download
    versions = {}

    UserAvatar::SIZES.each do |size|
      versions["image_#{size}".to_sym] = resize_to_fill(original, size, size)
    end

    versions
  end
end
