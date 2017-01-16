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

    @sizes.each do |size|
      versions["image_#{size}".to_sym] = resize_to_fill(original, size, size)
    end

    versions
  end
end
