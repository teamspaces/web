class DeviceUsersCookie

  def initialize(cookies)
    @cookies = cookies
    @cookie = cookies[:signed_in_user_ids]

    @user_ids = []
    @user_ids = JSON.parse(@cookie) if @cookie.present?
  end

  def add(user)
    @user_ids << user.id if !@user_ids.include? user.id
    save
  end

  def remove(user)
    @user_ids.delete(user.id)
    save
  end

  def users
    @user_ids.map { |user_id| User.find_by(id: user_id) }
  end

  def teams
    users.map { |user| user.teams }.flatten.uniq
  end

  private

    def save
      @cookies[:signed_in_user_ids] = { value: @user_ids.to_json, domain: :all,  tld_length: 2}
    end
end
