module CustomAuthentication

  #overwrite devise
  def sign_in(user)
    self.current_user = user
  end

  def sign_out(user)
    logout_from_current_team
  end

  def authenticate_user!(opts={})
    if !logged_in? && (!devise_controller? || opts.delete(:force))
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), :alert => "You must login to view this resource"
    end
  end


  def logout_from_current_team
    auth_session.invalidate!
  end

  def logout_from_all_user_teams_on_device
    Authie::Session.where(user: current_user, browser_id: auth_session.browser_id).each do |s|
      s.invalidate!
    end
  end

  def logout_from_all_teams_on_device
    Authie::Session.where(browser_id: auth_session.browser_id).each do |s|
      s.invalidate!
    end
  end
end
