module LoginRegisterFunnel::PrecedingFunnelStepsInfo

  private

    def in_login_register_funnel_provided_email_address=(email_address)
      session[:user_email_address] = email_address
    end

    def in_login_register_funnel_provided_email_address
      session[:user_email_address]
    end
end
