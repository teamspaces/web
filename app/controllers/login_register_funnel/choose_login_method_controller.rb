class LoginRegisterFunnel::ChooseLoginMethodController < LoginRegisterFunnelController

  def index
    if params[:create_team]
      shared_user_info.user_wants_to_create_team = true
    else
      shared_user_info.user_wants_to_create_team = false
    end
  end
end
