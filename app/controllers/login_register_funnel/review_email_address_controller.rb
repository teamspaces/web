class LoginRegisterFunnel::ReviewEmailAddressController < LoginRegisterFunnelController

  def new
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new
  end

  def review
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new(email_address_form_params)

    if @email_address_form.valid?
      existing_user = User.find_by(email: @email_address_form.email)
      session[:user_email_address] = @email_address_form.email

      if existing_user
        if existing_user.allow_email_login
          redirect_to new_email_login_path
        else
          redirect_to slack_login_path, notice: "Please sign in with your Slack Account"
        end
      else
        redirect_to new_email_register_path
      end
    else
      render :new
    end
  end

  private
    def email_address_form_params
      params.require(:login_register_funnel_email_address_form).permit(:email)
    end
end
