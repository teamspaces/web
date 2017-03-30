class User::SignOut
  include Interactor

  attr_reader :user, :team, :browser

  def call
    @user = context&.user
    @team = context&.from_team
    @browser = context&.from_browser

    sign_out
  end

  private

    def sign_out
      matching_user_sessions.find_each(&:invalidate!)
    end

    def matching_user_sessions
      sessions = matching_active_user_sessions
      sessions = matching_team_sessions(sessions) if team.present?
      sessions = matching_browser_sessions(sessions) if browser.present?
      sessions
    end

    def matching_active_user_sessions
      user_sessions = Authie::Session.active
      user_sessions = user_sessions.where(user_id: user.id) if user.is_a?(User)
      user_sessions
    end

    def matching_team_sessions(sessions)
      sessions.where(team_id: team.id)
    end

    def matching_browser_sessions(sessions)
      sessions.where(browser_id: browser)
    end
end
