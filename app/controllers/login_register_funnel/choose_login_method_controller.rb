class LoginRegisterFunnel::ChooseLoginMethodController < LoginRegisterFunnelController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo

  def index
    set_after_sign_in_action
  end
end
