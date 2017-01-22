class User::EmailConfirmationsController < SubdomainBaseController
  before_action :set_user, :check_for_open_email_confirmation
  skip_before_action :check_email_confirmation

  def new
    @update_email_form = ::EmailConfirmation::UpdateEmailForm.new(@user)
  end

  def create
    @user.send_confirmation_instructions

    redirect_to new_user_email_confirmation_path
  end

  def update
    @update_email_form = ::EmailConfirmation::UpdateEmailForm.new(@user, user_params.to_h)

    if @update_email_form.save
      redirect_to new_user_email_confirmation_path
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end

    def set_user
      @user = current_user.decorate
    end

    def check_for_open_email_confirmation
      unless current_user.email_confirmation_required?
        redirect_to root_subdomain_path
      end
    end
end
