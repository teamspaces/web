class LoginRegisterFunnel::EmailConfirmationController < LoginRegisterFunnel::BaseController
  before_action :redirect_unless_user_completed_review_email_address_step

  def new

  end


  private

    def email_login_form_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end
end
