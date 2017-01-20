class EmailConfirmationController < SubdomainBaseController

  skip_before_action :check_confirmed_email

  def new

  end


  private

    def email_login_form_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end
end
