class UserAvatarUploader < BaseUploader

  def generate_location(io, context)
    type  = "user_avatar"
    version = context[:version] if context[:version]
    name  = super # the default unique identifier

    [type, version, name].compact.join("/")
  end

  def process(io, context)
    case context[:phase]
      when :store
        ImageVersionsGenerator.call(io: io, sizes: UserAvatar::SIZES).versions
    end
  end

  add_metadata :source do |io, context|
    context[:source] || context[:record][:avatar_data]["metadata"]["source"]
  end

  Attacher.default_url do |options|
    "default_avatar.png"
  end
end
