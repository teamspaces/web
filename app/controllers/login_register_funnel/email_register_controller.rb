class LoginRegisterFunnel::EmailRegisterController < LoginRegisterFunnel::BaseController
  before_action :redirect_unless_user_completed_review_email_address_step

  def new
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email: shared_user_info.reviewed_email_address)
    @existing_slack_user_with_same_email = User.find_by(email: shared_user_info.reviewed_email_address, allow_email_login: false)
  end

  def create
    @email_register_form = LoginRegisterFunnel::EmailRegisterForm.new(email_register_form_params.to_h)
    @email_register_form.team = subdomain_team if on_team_subdomain?

    if @email_register_form.save

      redirect_to sign_in_url_for(user: @email_register_form.user)
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
