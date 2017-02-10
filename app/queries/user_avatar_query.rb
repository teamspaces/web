class UserAvatarQuery

   AVATAR_USERS_TO_SHOW = 3


     helper_method :avatar_users
  def avatar_users

  end

  helper_method :number_of_unseen_avatars
  def number_of_unseen_avatars
    @number_of_unseen_avatars ||=
      [(current_team.users.count - AVATAR_USERS_TO_SHOW), 0].max
  end


  def for_team(team)
    user_ids = team.users
                   .limit(100)
                   .pluck(:id)
                   .sample(AVATAR_USERS_TO_SHOW)

    User.where(id: @avatar_user_ids).all
  end


  def for_space(space)

  end

end
