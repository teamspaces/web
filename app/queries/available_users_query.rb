class AvailableUsersQuery

  def initialize(browser_id)
    @browser_id = browser_id
  end

  def users
    User.where(id: available_user_ids)
  end

  def teams
    Team.joins(:users).where(users: { id: available_user_ids })
  end

  def user_signed_in_on_another_subdomain(team)
    users.joins(:teams).where(teams: { id: team.id }).limit(1).first
  end

  private

    def available_user_ids
      active_browser_sessions.select(:user_id).distinct
    end

    def active_browser_sessions
      Authie::Session.active.where(browser_id: @browser_id)
    end
end
