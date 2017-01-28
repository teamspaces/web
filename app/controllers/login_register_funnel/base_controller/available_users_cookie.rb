class LoginRegisterFunnel::BaseController::AvailableUsersCookie

  def initialize(cookies)
    @cookies = cookies
  end

  def available_user_ids
    @available_user_ids ||= Authie::Session.where(browser_id: @cookies[:browser_id], active: true)
                                           .select(:user_id)
                                           .distinct
  end

  def users
    User.where(id: available_user_ids)
  end

  def teams
    Team.joins(:users).where(users: {id: available_user_ids})
  end
end
