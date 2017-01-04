class LoginRegisterFunnelController < ApplicationController
  include LoginRegisterFunnel::SharedUserInformation
  include LoginRegisterFunnel::SignInPathForUser

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in

  private

    def redirect_if_user_already_signed_in
      if current_user
        user = current_user

        sign_out_user_from_default_subdomain(user)
        return redirect_to sign_in_path_for(user)
      end
    end

    def sign_out_user_from_default_subdomain(user)
      sign_out(user)
    end
end
