class LoginRegisterFunnel::BaseController::AvailableUsersCookie

  def initialize(cookies)
    @cookies = cookies
  end

  def users
    User.where(id: Authie::Session.where(browser_id: @cookies[:browser_id], active: true)
                                  .select(:user_id)
                                  .distinct)
  end

  def teams
    Team.where(id: Authie::Session.where(browser_id: @cookies[:browser_id], active: true)
                                  .select(:team_id))
  end
end
