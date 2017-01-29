module SessionAuthentication

  #overwrite devise
  def sign_in(user)
    self.current_user = user
  end

  def sign_out(resource_or_scope = nil)
    sign_out_from_users_subdomains
  end

  def authenticate_user!(opts={})
    if !logged_in? && (!devise_controller? || opts.delete(:force))
      if on_team_subdomain? && available_users.teams.include?(current_team)
        sign_in(available_users.available_user_member_of_team(current_team))
      else
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), alert: t("errors.messages.unauthorized")
      end
    end
  end


  def sign_out_from_subdomain
    auth_session.invalidate!
  end

  def sign_out_from_users_subdomains
    Authie::Session.where(user: current_user, browser_id: auth_session.browser_id).each(&:invalidate!)
  end

  def sign_out_from_all_subdomains_in_browser
    Authie::Session.where(browser_id: auth_session.browser_id).each(&:invalidate!)
  end
end
