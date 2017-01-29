class AvailableUsersQuery

  def initialize(cookies)
    @cookies = cookies
  end

  def users
    User.where(id: available_user_ids)
  end

  def teams
    Team.joins(:users).where(users: {id: available_user_ids})
  end

  def team_user(team)
    users.joins(:teams).where(teams: {id: team.id}).limit(1).first
  end

  private

    def available_user_ids
      @available_user_ids ||= Authie::Session.where(browser_id: @cookies[:browser_id], active: true)
                                             .select(:user_id)
                                             .distinct
    end

end
