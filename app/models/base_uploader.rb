class BaseUploader < Shrine
  plugin :logging
  plugin :versions # save different avatar versions
  plugin :delete_raw # delete processed files after uploading
  plugin :processing
  plugin :default_url
  plugin :add_metadata
  plugin :remove_invalid
  plugin :cached_attachment_data # enables caching the form
  plugin :determine_mime_type # determines MIME type from file content
  plugin :validation_helpers, default_messages: {
    mime_type_inclusion: ->(list) { I18n.t("errors.file.mime_type_inclusion", list: list.join(", ")) },
    max_size: ->(max) { I18n.t("errors.file.max_size", max: max.to_f/1024/1024) }
  }

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png]
    validate_max_size 8*1024*1024
  end

  def class_field_name
    #example: Team.logo = team_logo / Space.cover = space_cover
    "#{context[:record].class.name.underscore}_#{context[:name]}"
  end

  def generate_location(io, context)
    version = context[:version] if context[:version]
    name  = super # the default unique identifier

    [class_field_name, version, name].compact.join("/")
  end

  add_metadata :source do |io, context|
    context[:source] || context[:record]["#{context[:name]}_data".to_sym]["metadata"]["source"]
  end

  Attacher.default_url do |options|
    "default_#{class_field_name}.jpg"
  end
end
