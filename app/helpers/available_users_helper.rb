module AvailableUsersHelper
  def available_users
    @available_users ||= AvailableUsersCookie.new(cookies)
  end
end
