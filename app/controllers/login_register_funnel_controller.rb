class LoginRegisterFunnelController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in

  private

    def redirect_if_user_already_signed_in
      redirect_to user_sign_in_path(current_user) if current_user
    end
end
