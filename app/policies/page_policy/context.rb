class PagePolicy::Context

  attr_reader :user, :team, :space

  def initialize(user, team, space)
    @user = user
    @team = team
    @space = space
  end
end
