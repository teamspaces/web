class User::Avatar::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    attach_avatar
  end

  def attach_avatar
    avatar_image = generated_avatar_image

    @user.avatar_attacher.context[:source] = User::Avatar::Source::GENERATED
    @user.avatar_attacher.assign(avatar_image)
  end

  private

    def generated_avatar_image
      FakeIO.new(Avatarly.generate_avatar(@user.name, { size: 1024 }))
    end
end
