class User::Avatar::VersionsGenerator
  include ImageProcessing::MiniMagick
  include Interactor

  def call
    @io = context.io

    context.versions = generate_versions
  end

  def generate_versions
    original = @io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

    { original: @io, large: size_500, medium: size_300, small: size_100 }
  end
end
