class LoginRegisterFunnel::EmailLoginController < LoginRegisterFunnelController
  include LoginRegisterFunnel::CheckUserCompletedPrecedingFunnelSteps

  def new
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email: session[:user_email_address])
  end

  def create
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email_login_params.to_h)

    if @email_login_form.valid?
      user = @email_login_form.user

      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new
    end
  end

  private

    def email_login_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end
end
