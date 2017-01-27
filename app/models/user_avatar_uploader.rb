class UserAvatarUploader < BaseUploader

  def process(io, context)
    case context[:phase]
      when :store
        ImageVersionsGenerator.call(io: io, sizes: UserAvatar::SIZES).versions
    end
  end
end
