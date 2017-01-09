class AvailableUsersCookie

  COOKIE_NAME = :device_user_ids
  COOKIE_DOMAIN = :all

  def initialize(cookies)
    @cookies = cookies

    invitation_cookie = @cookies.signed[COOKIE_NAME]
    @user_ids = invitation_cookie.present? ? JSON.parse(invitation_cookie) : []
  end

  def add(user)
    @user_ids << user.id if !@user_ids.include? user.id
    save(@user_ids)
  end

  def remove(user)
    @user_ids.delete(user.id)
    save(@user_ids)
  end

  def users
    User.where(id: @user_ids)
  end

  def teams
    Team.joins(:users).where("users.id": @user_ids).distinct
  end

  private

    def save(user_ids)
      @cookies.signed[COOKIE_NAME] = { value: user_ids.to_json,
                                       domain: COOKIE_DOMAIN,
                                       tld_length: 2 }
    end
end
