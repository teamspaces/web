module UserTeamsFunnel::CurrentUser

  private

    def set_user_teams_funnel_current_user(user)
      cookies.signed[:user_teams_funnel_current_user] = { value: user.id,
                                                          domain: :all, tld_length: 2,
                                                          expires: 5.minutes.from_now }
    end

    def user_teams_funnel_current_user
      User.find(cookies.signed[:user_teams_funnel_current_user])
    end

    def remove_user_teams_funnel_current_user
      cookies.delete :user_teams_funnel_current_user, domain: :all, tld_length: 2
    end
end
