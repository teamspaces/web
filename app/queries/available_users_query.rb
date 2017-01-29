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

  def available_user_member_of_team(team)
    users.joins(:teams).where(teams: {id: team.id}).limit(1).first
  end

  def sign_out(user)
    Authie::Session.where(user: user, browser_id: @cookies[:browser_id]).each(&:invalidate!)
  end

  def sign_out_all
    Authie::Session.where(browser_id: @cookies[:browser_id]).each(&:invalidate!)
  end

  private

    def available_user_ids
      @available_user_ids ||= Authie::Session.where(browser_id: @cookies[:browser_id], active: true)
                                             .select(:user_id)
                                             .distinct
    end

end
