class Shrine::AvatarUploader < Shrine
  # plugins and uploading logic

  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :add_metadata

  process(:store) do |io, context|
    original = io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

    {original: io, large: size_500, medium: size_300, small: size_100}
  end

  add_metadata :custom do |io, context|
    true
  end
end
