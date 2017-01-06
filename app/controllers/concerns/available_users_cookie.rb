class AvailableUsersCookie

  COOKIE_NAME = :device_user_ids
  COOKIE_DOMAIN = :all

  def initialize(cookies)
    @cookies = cookies
    @user_ids = @cookies[COOKIE_NAME].present? ? JSON.parse(@cookies[COOKIE_NAME]) : []
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
      @cookies.signed[COOKIE_NAME] = { value: user_ids.to_json, domain: COOKIE_DOMAIN,  tld_length: 2 }
    end
end
