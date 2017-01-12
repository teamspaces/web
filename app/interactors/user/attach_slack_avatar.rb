class User::AttachSlackAvatar
  include Interactor

  def call
    @user = context.user
    @slack_identity = context.slack_identity

    #rename
    find_highest_resolution_slack_avatar_and_attach_to_user
  end

  #rename
  def find_highest_resolution_slack_avatar_and_attach_to_user
    size = highest_resolution_size_available
    context.fail! unless size

    attach_slack_avatar_to_user(size)
  end

  #rename
  def attach_slack_avatar_to_user(size)
    @user.avatar_attacher.context[:source] = User::Avatar::Source::SLACK
    @user.avatar_attacher.assign(open(@slack_identity.user[size]))
  end

  private
  #rename
    def highest_resolution_size_available
      available_avatar_sizes = [:image_1024, :image_512, :image_192, :image_72, :image_48, :image_32, :image_24]
      available_avatar_sizes.find { |size| @slack_identity.user[size].present? }
    end
end
