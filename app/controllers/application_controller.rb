class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!






  def sign_in_url_for(options)
    available_users.add(options[:user])

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

  #overwrite devise
  def sign_in(user)
    self.current_user = user
  end

  def sign_out(user)
    logout_from_current_team
  end

  ### FROM DEVISE

  # def authenticate_#{mapping}!(opts={})
  #   opts[:scope] = :#{mapping}
  #   warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
  # end

  # https://github.com/plataformatec/devise/blob/master/lib/devise/controllers/helpers.rb

  #logged_in? from authie

  def authenticate_user!(opts={})
    if (!devise_controller? || opts.delete(:force))
      unless logged_in?
       redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], hello: "ASDF"), :alert => "You must login to view this resource"
      end
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



  helper_method :available_users

  def available_users
    available_users ||= LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(cookies)
  end
end
