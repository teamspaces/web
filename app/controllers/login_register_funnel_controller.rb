class LoginRegisterFunnelController < ApplicationController
  include InvitationCookie

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in
  before_action :set_invitation_cookie_from_params

  private

    def redirect_if_user_already_signed_in
      redirect_to user_after_sign_in_path if current_user
    end

    def check_user_completed_preceding_funnel_steps
      redirect_to choose_login_method_path unless user_already_provided_email_address?
    end

    def user_already_provided_email_address?
      session[:user_email_address]
    end
end
