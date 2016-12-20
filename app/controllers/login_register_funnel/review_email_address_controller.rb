class LoginRegisterFunnel::ReviewEmailAddressController < LoginRegisterFunnelController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo

  def new
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new
  end

  def review
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new(email_address_form_params.to_h)

    if @email_address_form.valid?
      existing_user = User.find_by(email: @email_address_form.email)&.decorate
      in_login_register_funnel_provided_email_address = @email_address_form.email

      existing_user.switch(
        nil?: -> { redirect_to new_email_register_path },
        login_using_email?: -> { redirect_to new_email_login_path },
        login_using_slack?: -> { redirect_to slack_login_path, notice: "Please sign in with your Slack Account" }
      )
    else
      render :new
    end
  end

  private
    def email_address_form_params
      params.require(:login_register_funnel_email_address_form).permit(:email)
    end
end
