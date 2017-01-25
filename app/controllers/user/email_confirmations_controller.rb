class User::EmailConfirmationsController < SubdomainBaseController
  before_action :set_user, :redirect_if_already_confirmed
  skip_before_action :verify_email_confirmed

  def new
    @update_email_form = ::User::UpdateEmailForm.new(@user)
  end

  def create
    @user.send_confirmation_instructions(controller: self)

    redirect_to new_user_email_confirmation_path
  end

  def update
    @update_email_form = ::User::UpdateEmailForm.new(@user, user_params.to_h)

    if @update_email_form.save
      @user.send_confirmation_instructions(controller: self)

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

    def redirect_if_already_confirmed
      unless current_user.email_confirmation_required?
        redirect_to root_subdomain_path
      end
    end
end
