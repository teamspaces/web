class LoginRegisterFunnel::BaseController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in

  private

    def redirect_if_user_already_signed_in
      if current_user
        user = current_user

        sign_out_user_from_default_subdomain(user)
        return redirect_to sign_in_url_for(user: user)
      end
    end

    def sign_out_user_from_default_subdomain(user)
      sign_out(user)
    end

    def shared_user_info
      @shared_user_info ||= LoginRegisterFunnel::BaseController::SharedUserInformation.new(session)
    end

    def redirect_unless_user_completed_review_email_address_step
      redirect_to choose_login_method_path unless shared_user_info.reviewed_email_address.present?
    end
end
