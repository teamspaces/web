class LoginRegisterFunnel::ResetPasswordController < LoginRegisterFunnel::BaseController
  before_action :redirect_unless_user_completed_review_email_address_step, :set_user

  def new
    @email_address_form = LoginRegisterFunnel::PasswordResetForm.new(email: email_params)
  end

  def create
    render :show
  end

  def show

  end

  private

    def email_params
      params[:email]
    end

    def set_user
      @user = User.find_for_authentication(email: shared_user_info.reviewed_email_address)
    end
end
