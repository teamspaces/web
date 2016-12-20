module LoginRegisterFunnel::PrecedingFunnelStepsInfo

  private

    def in_login_register_funnel_provided_email_address=(email_address)
      session[:user_email_address] = email_address
    end

    def in_login_register_funnel_provided_email_address
      session[:user_email_address]
    end

    def set_after_sign_in_action
      session[:after_sign_in_action] = params[:after_sign_in_action]
    end

    def after_sign_in_action
      session[:after_sign_in_action]&.to_sym
    end
end
