class EmailConfirmationController < SubdomainBaseController

  skip_before_action :check_confirmed_email

  def new

  end

  def resend
    current_user.send_confirmation_instructions

    redirect_to new_email_confirmation_path
  end

  def update_email

  end

  private

    def email_login_form_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end
end
