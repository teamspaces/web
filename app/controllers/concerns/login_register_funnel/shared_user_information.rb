class LoginRegisterFunnel::SharedUserInformation

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
    @session[:user_wants_to_create_team_after_sign_in] = boolean
  end

  def team_creation_requested?
    @session[:user_wants_to_create_team_after_sign_in]
  end
end
