class EmailConfirmationController < SubdomainBaseController
  before_action :set_user
  skip_before_action :check_confirmed_email

  def new
    @update_email_form = EmailConfirmation::UpdateEmailForm.new(current_user)
  end

  def resend
    current_user.send_confirmation_instructions

    redirect_to new_email_confirmation_path
  end

  def update_email
    @update_email_form = EmailConfirmation::UpdateEmailForm.new(current_user, email_params)

    if @update_email_form.save
      redirect_to new_email_confirmation_path
    else
      render :new
    end
  end

  private

    def email_params
      params.require(:user).permit(:email)
    end

    def set_user
      @user = current_user
    end
end
