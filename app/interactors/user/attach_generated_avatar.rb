class User::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    generate_and_attach_avatar_to_user
  end

  def generate_and_attach_avatar_to_user
    file = Tempfile.new("avatar_temp.png", encoding: "ascii-8bit")
    file.write(Avatarly.generate_avatar(@user.name))

    attach_avatar_file_to_user(file)

    file.close
    file.delete
  end

  def attach_avatar_file_to_user(file)
    attacher = Shrine::AvatarUploader::Attacher.new(@user, :avatar)
    attacher.context[:source] = User::Avatar::Source::GENERATED
    attacher.assign(file)
  end
end
