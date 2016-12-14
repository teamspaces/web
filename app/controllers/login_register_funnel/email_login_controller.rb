  skip_before_action :authenticate_user!

  def choose_sign_in_method

  end

  def email_sign_in_method
    @email_address_form = LoginSignUpFunnel::EmailAddressForm.new
  end

  def check_email_address
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
      render :email_sign_in_method
    end
  end

  def email_register
    @resource = User.new
  end

  def slack_sign_in_method

  end

  private

    def email_address_form_params
      params.require(:login_sign_up_funnel_email_address_form).permit(:email)
    end
