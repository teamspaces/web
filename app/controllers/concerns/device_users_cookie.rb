class DeviceUsersCookie

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
    @user_ids.map { |user_id| User.find_by(id: user_id) }.compact
  end

  def teams
    users.map(&:teams).flatten.uniq
  end

  private

    def save(user_ids)
      @cookies[COOKIE_NAME] = { value: user_ids.to_json, domain: COOKIE_DOMAIN,  tld_length: 2}
    end
end
