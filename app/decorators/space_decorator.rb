class SpaceDecorator < Draper::Decorator
  delegate_all


  AVATAR_USERS_TO_SHOW = 3

  def avatar_users
    @avatar_user_ids ||=
      user_ids = users.limit(100)
                      .pluck(:id)
                      .sample(AVATAR_USERS_TO_SHOW)

    @avatar_users ||= User.where(id: @avatar_user_ids).all
  end


  def number_of_unseen_avatars
    @number_of_unseen_avatars ||=
      [(users.count - AVATAR_USERS_TO_SHOW), 0].max
  end

end