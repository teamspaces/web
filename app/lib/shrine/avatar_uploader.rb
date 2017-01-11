class Shrine::AvatarUploader < Shrine
  # plugins and uploading logic

  include ImageProcessing::MiniMagick
  plugin :processing

  process(:store) do |io, context|
    resize_to_limit!(io.download, 100, 100)
  end
end
