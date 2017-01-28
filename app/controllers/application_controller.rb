class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin
  include SessionAuthentication
  include EmailConfirmationWithToken

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

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
    @available_users ||= LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(cookies)
  end
end
