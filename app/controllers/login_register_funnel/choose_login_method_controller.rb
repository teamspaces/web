class LoginRegisterFunnel::ChooseLoginMethodController < LoginRegisterFunnelController

  def index
    if params[:create_team]
      set_user_clicked_on_create_team(true)
    else
      set_user_clicked_on_create_team(false)
    end
  end
end
