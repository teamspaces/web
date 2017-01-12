class AvatarThumbnailsGenerator
  include ImageProcessing::MiniMagick
  include Interactor

  def call
    original = context.io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

    context.versions = { original: context.io,
                         large: size_500,
                         medium: size_300,
                         small: size_100 }
  end
end
