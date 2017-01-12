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
  plugin :validation_helpers
  opts[:processor] = AvatarThumbnailsGenerator

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
    validate_max_size 3*1024*1024, message: "is too large (max is 3 MB)"
  end


  process(:store) do |io, context|


          original = io.download

    size_500 = resize_to_limit!(original, 500, 500)
    size_300 = resize_to_limit(size_500,  300, 300)
    size_100 = resize_to_limit(size_300,  100, 100)

      {original: io,
     large: size_500,
     medium: size_300,
     small: size_100}

    #opts[:processor].call(io, context)






  end

  add_metadata :source do |io, context|
     context[:source]
  end

# add real mising to app
  Attacher.default_url do |options|
    "/#{name}/missing.jpg"
  end

end
