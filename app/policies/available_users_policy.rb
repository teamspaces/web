class AvailableUsersPolicy
  attr_reader :available_users, :user

  def initialize(available_users, user)
    @available_users = available_users
    @user = user
  end

  def create_team?
    available_users.users.include?(user)
  end
end
