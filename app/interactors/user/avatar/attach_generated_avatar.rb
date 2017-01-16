class User::Avatar::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    attach_avatar
  end

  def attach_avatar
    avatar_image = generated_avatar_image

    @user.avatar_attacher.context[:source] = UserAvatar::Source::GENERATED
    @user.avatar_attacher.assign(avatar_image)
  end

  private

    def generated_avatar_image
      FakeIO.new(Avatarly.generate_avatar(@user.name, { size: UserAvatar::SIZES.max }), filename: "avatar.png")
    end
end
