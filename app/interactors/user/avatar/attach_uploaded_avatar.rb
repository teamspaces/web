class User::Avatar::AttachUploadedAvatar
  include Interactor

  def call
    @user = context.user
    @file = context.file

    attach_uploaded_avatar
  end

  def attach_uploaded_avatar
    @user.avatar_attacher.context[:source] = UserAvatar::Source::UPLOADED
    @user.avatar_attacher.assign(@file)
  end
end
