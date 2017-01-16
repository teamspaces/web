class ImageVersionsGenerator
  include ImageProcessing::MiniMagick
  include Interactor

  def call
    @io = context.io
    @sizes = context.sizes

    context.versions = generate_versions
  end

  def generate_versions
    original = @io.download
    versions = {}

    jpg_version = convert!(original, "jpg")

    @sizes.each do |size|
      versions["image_#{size}".to_sym] = resize_to_fill(jpg_version, size, size)
    end

    versions
  end
end
