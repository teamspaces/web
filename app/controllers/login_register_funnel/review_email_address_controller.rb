class LoginRegisterFunnel::ReviewEmailAddressController < LoginRegisterFunnelController

  def new
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new
  end

  def review
    @email_address_form = LoginRegisterFunnel::EmailAddressForm.new(email_address_form_params.to_h)

    if @email_address_form.valid?
      existing_email_user = User.find_for_authentication(email: @email_address_form.email)&.decorate
      set_users_reviewed_email_address(@email_address_form.email)

      if existing_email_user
        redirect_to new_email_login_path
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
