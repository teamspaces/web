module LoginRegisterFunnel::SharedUserInformation
  extend ActiveSupport::Concern

    def check_user_completed_review_email_address_step
      redirect_to choose_login_method_path unless users_reviewed_email_address.present?
    end


    def set_users_reviewed_email_address(email_address)
      session[:users_reviewed_email_address] = email_address
    end

    def users_reviewed_email_address
      session[:users_reviewed_email_address]
    end


    def set_user_clicked_on_create_team(boolean)
      session[:user_wants_to_create_team_after_sign_in] = boolean
    end

    def user_clicked_on_create_team
      session[:user_wants_to_create_team_after_sign_in]
    end


    def set_invitation_token_cookie(invitation_token)
      cookies.signed[:invitation_token] = invitation_token
    end

    def invitation_token_cookie
      cookies.signed[:invitation_token]
    end

    def delete_invitation_token_cookie
      cookies.delete :invitation_token
    end
end
