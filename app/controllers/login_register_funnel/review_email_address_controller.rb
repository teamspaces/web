class LoginRegisterFunnel::ReviewEmailAddressController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @email_address_form = LoginSignUpFunnel::EmailAddressForm.new
  end

  def review
    @email_address_form = LoginSignUpFunnel::EmailAddressForm.new(email_address_form_params)

    if @email_address_form.valid?
      existing_user = User.find_by(email: @email_address_form.email)

      if existing_user
        if existing_user.allow_email_login
          redirect_to new_user_session_path(email: @email_address_form.email)
        else
          redirect_to slack_sign_in_method_path, alert: "Please sign in with your Slack Account"
        end
      else
        redirect_to email_register_path(email: @email_address_form.email)
      end
    else
      render :new
    end
  end

  private
    def email_address_form_params
      params.require(:login_sign_up_funnel_email_address_form).permit(:email)
    end
end
