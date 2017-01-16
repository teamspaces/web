class UserAvatarUploader < Shrine
  plugin :logging
  plugin :recache
  plugin :versions # save different avatar versions
  plugin :delete_raw # delete processed files after uploading
  plugin :processing
  plugin :default_url
  plugin :add_metadata
  plugin :remove_invalid
  plugin :delete_promoted
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

  def generate_location(io, context)
    type  = "user_avatar"
    version = context[:version] if context[:version]
    name  = super # the default unique identifier

    [type, version, name].compact.join("/")
  end

  def process(io, context)
    case context[:phase]
      when :store
        User::Avatar::VersionsGenerator.call(io: io).versions
    end
  end

  add_metadata :source do |io, context|
    context[:source] || context[:record][:avatar_data]["metadata"]["source"]
  end

  Attacher.default_url do |options|
    "default_avatar.png"
  end
end
