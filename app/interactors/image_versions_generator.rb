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

    @sizes.each do |width, height|
      height = width if height.nil?

      versions["image_#{width}".to_sym] = resize_to_fill(jpg_version, width, height)
    end

    versions
  end
end
