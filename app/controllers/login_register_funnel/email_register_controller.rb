class LoginRegisterFunnel::EmailRegisterController < LoginRegisterFunnelController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo
  include LoginRegisterFunnel::CheckUserCompletedPrecedingFunnelSteps

  def new
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email: in_login_register_funnel_provided_email)
  end

  def create
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email_register_params.to_h)

    if @email_register_form.save
      user = @email_register_form.user

      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new
    end
  end

  private

    def email_register_params
      params.require(:login_register_funnel_email_register_form)
            .permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
