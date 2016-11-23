class ApplicationController < ActionController::Base
  include Pundit
  include HTTPBasicAuthentication
  include TokenParamLogin
  include UserAfterSignInPath

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_sign_in_path_for(_resource)
    AcceptInvitation.call(user: current_user,
                          token: params[:invitation_token]) if params[:invitation_token]
    user_after_sign_in_path
  end

  def after_sign_out_path_for(_resource)
    landing_url
  end

   protected
    def configure_permitted_parameters
       devise_parameter_sanitizer.permit(:sign_up, keys: [:invitation_token])
       devise_parameter_sanitizer.permit(:sign_in, keys: [:invitation_token])
    end
end
