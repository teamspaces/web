class User::EmailConfirmationsController < SubdomainBaseController
  before_action :set_user, :redirect_if_already_confirmed
  skip_before_action :verify_email_confirmed

  def new
    @update_email_form = ::User::UpdateEmailForm.new(user: @user)
  end

  def create
    User::Email::SendConfirmationInstructions.call(user: current_user, controller: self)

    redirect_to new_user_email_confirmation_path
  end

  def update
    @update_email_form = ::User::UpdateEmailForm.new(user: current_user, attributes: user_params)

    if @update_email_form.save
      User::Email::SendConfirmationInstructions.call(user: current_user, controller: self)

      redirect_to new_user_email_confirmation_path
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email).to_h
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
