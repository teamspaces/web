class AccountsPolicy
  attr_reader :available_users, :user

  def initialize(available_users, user)
    @available_users = available_users
    @user = user
  end

  def create_team?
    available? && UserPolicy.new(default_context, user).create_team?
  end

  def available?
    available_users.users.include?(user)
  end

  private

    def default_context
      DefaultContext.new(user, nil)
    end
end
