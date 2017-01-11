class User::AttachDefaultAvatar
  include Interactor

  def call
    @user = context.user

    action
  end

  def action
    attacher = Shrine::AvatarUploader::Attacher.new(@user, :avatar)
    img = Avatarly.generate_avatar(@user.name)
    temp_file = Tempfile.new("avatar_temp.png", encoding: "ascii-8bit")
    temp_file.write(img)
    attacher.assign(temp_file)
    temp_file.close
    temp_file.delete
  end
end
