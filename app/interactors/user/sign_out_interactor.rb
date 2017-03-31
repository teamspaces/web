class User::SignOutInteractor
  include Interactor

  attr_reader :user, :team, :browser

  def call
    # optional arguments, if no arguments provided sign out all users
    @user = context&.user
    @team = context&.from_team
    @browser = context&.from_browser

    sign_out
  end

  private

    def sign_out
      user_sessions.find_each(&:invalidate!)
    end

    def user_sessions
      sessions = active_user_sessions
      sessions = matching_user_sessions(sessions) if user.present?
      sessions = matching_team_sessions(sessions) if team.present?
      sessions = matching_browser_sessions(sessions) if browser.present?
      sessions
    end

    def active_user_sessions
      Authie::Session.active
    end

    def matching_user_sessions(sessions)
      sessions.where(user_id: user.id)
    end

    def matching_team_sessions(sessions)
      sessions.where(team_id: team.id)
    end

    def matching_browser_sessions(sessions)
      sessions.where(browser_id: browser)
    end
end
