class LoginRegisterFunnel::ChooseLoginMethodController < LoginRegisterFunnelController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo

  def index
    after_sign_in_action = params[:after_sign_in_action]
  end
end
