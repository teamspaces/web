class User::AttachSlackAvatar
  include Interactor

  def call
    @user = context.user
    @slack_identity = context.slack_identity

    action
  end

  def action
      available_avatar_sizes = [:image_1024, :image_512, :image_192, :image_72, :image_48, :image_32, :image_24]
      size = available_avatar_sizes.find { |size| @slack_identity.user[size].present? }
      if size
        attacher = Shrine::AvatarUploader::Attacher.new(@user, :avatar)
        attacher.context[:source] = User::Avatar::Source::SLACK
        attacher.assign(open(@slack_identity.user[size]))
      else
        context.fail!
      end
  end
end
