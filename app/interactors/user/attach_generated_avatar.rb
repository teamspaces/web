class User::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    attach_avatar
  end

  def attach_avatar
    generated_avatar = FakeIO.new(Avatarly.generate_avatar(@user.name))

    @user.avatar_attacher.context[:source] = User::Avatar::Source::GENERATED
    @user.avatar_attacher.assign(generated_avatar)
  end
end
