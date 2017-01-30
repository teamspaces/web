module SessionAuthentication

  #overwrite devise
  def sign_in(resource_or_scope, *args)
    user = args.last || resource_or_scope
    self.current_user = user
  end

  def sign_out(user)
    sign_out_from_users_subdomains(user)
  end

  def authenticate_user!(opts={})
    if !logged_in? && (!devise_controller? || opts.delete(:force))
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), alert: t("errors.messages.unauthorized")
    end
  end


  def sign_out_from_subdomain
    auth_session.invalidate!
  end

  def sign_out_from_users_subdomains(user)
    Authie::Session.where(user: user, browser_id: auth_session.browser_id).each(&:invalidate!)
  end

  def sign_out_from_all_subdomains_in_browser
    Authie::Session.where(browser_id: auth_session.browser_id).each(&:invalidate!)
  end
end
