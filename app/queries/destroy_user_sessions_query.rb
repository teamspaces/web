class DestroyUserSessionsQuery

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def for_team!(team)
    active_user_sessions_for_team(team).find_each(&:invalidate!)
  end

  def for_browser!(browser_id)
    active_user_sessions_for_browser(browser_id).find_each(&:invalidate!)
  end

  private

    def active_user_sessions_for_team(team)
      active_user_sessions.where(team_id: team.id)
    end

    def active_user_sessions_for_browser(browser_id)
      active_user_sessions.where(browser_id: browser_id)
    end

    def active_user_sessions
      Authie::Session.active.where(user_id: user.id)
    end
end