class LoginRegisterFunnel::BaseController::SharedUserInformation

  def initialize(session)
    @session = session
  end

  def reviewed_email_address=(email_address)
    @session[:users_reviewed_email_address] = email_address
  end

  def reviewed_email_address
    @session[:users_reviewed_email_address]
  end

  def team_creation_requested=(boolean)
    @session[:user_team_creation_requested] = boolean
  end

  def team_creation_requested?
    !! @session[:user_team_creation_requested]
  end

  def team_creation_started!
    self.team_creation_requested = false
  end
end
