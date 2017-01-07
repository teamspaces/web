class LoginRegisterFunnel::EmailLoginController < LoginRegisterFunnelController
  before_action :redirect_unless_user_completed_review_email_address_step

  def new
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email: shared_user_info.reviewed_email_address)
  end

  def create
    @email_login_form = LoginRegisterFunnel::EmailLoginForm.new(email_login_form_params.to_h)

    if @email_login_form.valid?
      user = @email_login_form.user

      redirect_to sign_in_path_for(user, team_to_redirect_to)
    else
      render :new
    end
  end

  private

    def email_login_form_params
      params.require(:login_register_funnel_email_login_form).permit(:email, :password)
    end

    def team_to_redirect_to
      Team.find_by(id: request.subdomain)
    end
end
