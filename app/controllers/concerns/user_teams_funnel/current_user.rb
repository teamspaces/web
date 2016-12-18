module UserTeamsFunnel::CurrentUser

  private

    def set_user_teams_funnel_current_user(user)
      session[:user_email_address] = email_address

      cookies.signed[:user_teams_funnel_current_user] = { value: user.id,
                                                          domain: :all, tld_length: 2,
                                                          expires: 1.hour.from_now }
    end

    def user_teams_funnel_current_user
      User.find(cookies.signed[:user_teams_funnel_current_user])
    end
end
