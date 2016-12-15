class LoginRegisterFunnelController < ApplicationController
  skip_before_action :authenticate_user!

  private

    def check_user_completed_preceding_funnel_steps
      redirect_to choose_login_method_path unless user_provided_email_address?
    end

    def user_provided_email_address?
      session[:user_email_address]
    end
end
