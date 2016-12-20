class LoginRegisterFunnel::EmailLoginController < LoginRegisterFunnelController
  include LoginRegisterFunnel::CheckUserCompletedPrecedingFunnelSteps

  def new
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email: in_login_register_funnel_provided_email_address)
  end

  def create
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email_login_params.to_h)

    if @email_login_form.valid?
      user = @email_login_form.user

      redirect_to user_sign_in_path(user)
    else
      render :new
    end
  end

  private

    def email_login_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end
end
