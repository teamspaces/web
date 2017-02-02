class LoginRegisterFunnel::ResetPasswordsController < LoginRegisterFunnel::BaseController
  before_action :redirect_unless_user_completed_review_email_address_step, :set_user, only: :show

  def new
    @password_reset_form = LoginRegisterFunnel::PasswordResetForm.new(email: params[:email])
  end

  def create
    @password_reset_form = LoginRegisterFunnel::PasswordResetForm.new(password_reset_form_params)

    if @password_reset_form.send_reset_password_instructions
      shared_user_info.reviewed_email_address = @password_reset_form.email

      redirect_to login_register_funnel_reset_password_path
    else
      render :new
    end
  end

  def show
  end

  private

    def password_reset_form_params
      params.require(:login_register_funnel_password_reset_form).permit(:email).to_h
    end

    def set_user
      @user = User.find_for_authentication(email: shared_user_info.reviewed_email_address)
    end
end
