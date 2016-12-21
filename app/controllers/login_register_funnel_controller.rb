class LoginRegisterFunnelController < ApplicationController
  include LoginRegisterFunnel::SharedUserInformation

  skip_before_action :authenticate_user!
  before_action :redirect_if_user_already_signed_in

  private

    def redirect_if_user_already_signed_in
      #TODO
    end
end
