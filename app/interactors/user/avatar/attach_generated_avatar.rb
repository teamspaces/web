class User::Avatar::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    attach_avatar
  end

  def attach_avatar
    avatar_image = generated_avatar_image

    @user.avatar_attacher.context[:source] = Image::Source::GENERATED
    @user.avatar_attacher.assign(avatar_image)
  end

  private

    def generated_avatar_image
      jpg_blob = Avatarly.generate_avatar(@user.name, { background_color: "#0099E5",
                                                        size: UserAvatar::SIZES.max,
                                                        format: "jpg" })
      Shrine::FakeIO.new(jpg_blob, filename: "avatar.jpg")
    end
end
