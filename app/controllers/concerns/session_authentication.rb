module SessionAuthentication

  #overwrite devise
  def sign_in(resource_or_scope, *args)
    user = args.last || resource_or_scope

    self.current_user = user
  end

  def sign_out(resource_or_scope = nil)
    sign_out_from_users_subdomains
  end

  def authenticate_user!(opts={})
    if !logged_in? && (!devise_controller? || opts.delete(:force))
      if (available_user = available_user_signed_in_on_another_subdomain) && on_team_subdomain?
        sign_in(available_user)
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

  private

    def available_user_signed_in_on_another_subdomain
      if available_users.teams.include?(current_team)
        available_users.available_user_member_of_team(current_team)
      end
    end
end
