class User::EmailConfirmationsController < SubdomainBaseController
  before_action :set_user, :check_if_email_confirmation_open
  skip_before_action :check_confirmed_email

  def new
    @update_email_form = EmailConfirmation::UpdateEmailForm.new(@user)
  end

  def create
    @user.send_confirmation_instructions

    redirect_to new_user_email_confirmation_path
  end

  def update
    @update_email_form = EmailConfirmation::UpdateEmailForm.new(@user, email_params.to_h)

    if @update_email_form.save
      redirect_to new_user_email_confirmation_path
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

    def check_if_email_confirmation_open
      unless current_user.email_confirmation_required?
        redirect_to root_subdomain_path
      end
    end
end
