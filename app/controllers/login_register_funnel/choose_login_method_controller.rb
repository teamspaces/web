class LoginRegisterFunnel::ChooseLoginMethodController < LoginRegisterFunnel::BaseController

  def index
    if params[:create_team]
      shared_user_info.team_creation_requested = true
    else
      shared_user_info.team_creation_requested = false
    end
  end
end
