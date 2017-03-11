class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin
  include SessionAuthentication
  include EmailConfirmationWithToken

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!,
                :add_sentry_context

  def sign_in_url_for(options)
    User::SignInUrlDecider.call({ controller: self }.merge(options.to_h)).url
  end

  def after_sign_out_path_for(_resource)
    root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
  end

  def on_team_subdomain?
    subdomain_team.present?
  end

  def subdomain_team
    Team.find_by(subdomain: request.subdomain)
  end

  helper_method :available_users

  def available_users
    @available_users ||= AvailableUsersQuery.new(browser_id: cookies[:browser_id])
  end

  def add_sentry_context
    if user_signed_in?
      Raven.user_context(
          id: current_user.id,
          email: current_user.email,
          ip_address: request.remote_ip
        )

      if current_team
        Raven.extra_context(
            team_id: current_team.id,
            subdomain: current_team.subdomain
          )
      end
    else
      Raven.user_context(ip_address: request.remote_ip)
    end
  end
end
