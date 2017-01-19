class User::Avatar::AttachSlackAvatar
  include Interactor

  def call
    @user = context.user
    @slack_identity = context.slack_identity

    attach_avatar
  end

  def attach_avatar
    avatar_url = slack_avatar_url

    @user.avatar_attacher.context[:source] = Image::Source::SLACK
    @user.avatar_attacher.assign(open(avatar_url))
  end

  private

    def slack_avatar_url
      avatar_size = biggest_avatar_size_available
      context.fail! unless avatar_size

      @slack_identity.user[avatar_size]
    end

    def biggest_avatar_size_available
      available_avatar_sizes = [:image_1024, :image_512, :image_192, :image_72, :image_48, :image_32, :image_24]
      available_avatar_sizes.find { |size| @slack_identity.user[size].present? }
    end
end
