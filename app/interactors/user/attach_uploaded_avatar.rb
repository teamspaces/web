class User::AttachUploadedAvatar
  include Interactor

  def call
    @user = context.user
    @file = context.file

    attach_avatar
  end

  def attach_avatar
    attacher = Shrine::AvatarUploader::Attacher.new(@user, :avatar)
    attacher.context[:source] = User::Avatar::Source::UPLOADED
    attacher.assign(@file)
  end

end
