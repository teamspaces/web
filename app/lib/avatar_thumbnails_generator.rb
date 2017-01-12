class AvatarThumbnailsGenerator
  include ImageProcessing::MiniMagick
  include Interactor

  def call(io,context)
    puts "SDFSDFDSFDSFs"
    puts "SDFSDFDSFDF"
    puts "sadfsdfdf"
    original = io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

    {original: io, large: size_500, medium: size_300, small: size_100}

# ussee recachhhhhhee!!!

  #  case context[:phase]
  #  when :recache
  #    size_100 = resize_to_limit(original, 100, 100)
#
 #     {original: io, small: size_100}
 #   when :store
 #     size_500 = resize_to_limit!(original, 500, 500)
 #     size_300 = resize_to_limit(size_500,  300, 300)

  #    {large: size_500, medium: size_300}
  #  end
  end

end
