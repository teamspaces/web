class User::AttachGeneratedAvatar
  include Interactor

  def call
    @user = context.user

    attach_generated_avatar_to_user
  end

  def attach_generated_avatar_to_user
    generated_avatar = FakeIO.new(Avatarly.generate_avatar(@user.name))

    @user.avatar_attacher.context[:source] = User::Avatar::Source::GENERATED
    @user.avatar_attacher.assign(generated_avatar)
  end
end
