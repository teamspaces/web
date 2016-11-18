class DefaultContext
  attr_reader :user, :team

  def initialize(user, team)
    @user = user
    @team = team
  end
end
