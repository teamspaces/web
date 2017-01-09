module AvailableUsersHelper
  def available_users
    @available_users ||= LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(cookies)
  end
end
