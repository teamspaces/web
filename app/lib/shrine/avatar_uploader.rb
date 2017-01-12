class Shrine::AvatarUploader < Shrine
  plugin :recache
  plugin :default_url
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :add_metadata
  plugin :cached_attachment_data # enables caching the form
  plugin :determine_mime_type # determines MIME type from file content
  plugin :validation_helpers, default_messages: {
    mime_type_inclusion: ->(list) { I18n.t("errors.file.mime_type_inclusion", list: list.join(", ")) },
    max_size: ->(max) { I18n.t("errors.file.max_size", max: max.to_f/1024/1024) }
  }

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
    validate_max_size 3*1024*1024
  end

  def process(io, context)
    case context[:phase]
      when :store
        AvatarThumbnailsGenerator.call(io: io).versions
    end
  end

  add_metadata :source do |io, context|
     context[:source]
  end

  #file storage path

# add real mising to app
  Attacher.default_url do |options|
    "/#{name}/missing.jpg"
  end
end
