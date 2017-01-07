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

  def user_wants_to_create_team=(boolean)
    @session[:user_wants_to_create_team_after_sign_in] = boolean
  end

  def user_wants_to_create_team?
    @session[:user_wants_to_create_team_after_sign_in]
  end
end
