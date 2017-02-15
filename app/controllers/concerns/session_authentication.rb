module SessionAuthentication

  #overwrite devise
  def sign_in(resource_or_scope, *args)
    user = args.last || resource_or_scope
    self.current_user = user
  end

  def sign_out(_resource_or_scope = nil)
    DestroyUserSessionQuery.new(current_user)
                           .for_browser!(cookies[:browser_id])
  end

  def sign_out_from_subdomain
    auth_session.invalidate!
  end

  def user_signed_in?
    logged_in?
  end

  def authenticate_user!(opts={})
    if !user_signed_in? && (!devise_controller? || opts.delete(:force))
      sign_in_user_if_signed_in_on_another_subdomain || redirect_unauthorized
    end
  end

  private

    def sign_in_user_if_signed_in_on_another_subdomain
      if on_team_subdomain?
        available_user = available_users.user_signed_in_on_another_subdomain(current_team)

        sign_in(available_user) if available_user
      end
    end

    def redirect_unauthorized
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), alert: t("errors.messages.unauthorized")
    end
end
