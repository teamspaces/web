module SessionAuthentication

  #overwrite devise
  def sign_in(user)
    self.current_user = user
  end

  def sign_out(user)
    sign_out_from_subdomain
  end

  def authenticate_user!(opts={})
    if !logged_in? && (!devise_controller? || opts.delete(:force))
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), alert: t("errors.messages.unauthorized")
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
