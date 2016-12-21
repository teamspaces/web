class LoginRegisterFunnel::EmailRegisterController < LoginRegisterFunnelController
  before_action :check_user_completed_review_email_address_step

  def new
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email: users_reviewed_email_address)
  end

  def create
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email_register_form_params.to_h)

    if @email_register_form.save
      user = @email_register_form.user

      redirect_to sign_in_path_for(user)
    else
      render :new
    end
  end

  private

    def email_register_form_params
      params.require(:login_register_funnel_email_register_form)
            .permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
