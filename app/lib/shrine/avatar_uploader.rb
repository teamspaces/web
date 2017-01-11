class Shrine::AvatarUploader < Shrine
  # plugins and uploading logic

  include ImageProcessing::MiniMagick
  plugin :recache
  plugin :default_url
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :add_metadata
  plugin :cached_attachment_data # enables caching the form
  plugin :determine_mime_type # determines MIME type from file content

  process(:store) do |io, context|
    original = io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

    {original: io, large: size_500, medium: size_300, small: size_100}

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

  Attacher.default_url do |options|
    "/#{name}/missing.jpg"
  end

  add_metadata :source do |io, context|
    context[:source]
  end
end
