module LoginRegisterFunnel::SharedUserInformation
  extend ActiveSupport::Concern

    def check_user_completed_review_email_address_step
      redirect_to choose_login_method_path unless users_reviewed_email_address.present?
    end

    def users_reviewed_email_address=(email_address)
      session[:users_reviewed_email_address] = email_address
    end

    def users_reviewed_email_address
      session[:users_reviewed_email_address]
    end
end
