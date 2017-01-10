class LoginRegisterFunnel::BaseController::AvailableUsersCookie

  COOKIE_NAME = :available_user_ids
  COOKIE_DOMAIN = :all

  def initialize(cookies)
    @cookies = cookies

    @user_ids = case available_users_cookie_exisiting_and_valid?
      when true then JSON.parse(available_users_cookie)
      else []
    end
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

    def available_users_cookie_exisiting_and_valid?
      integer_array_schema = { type: "array", items: { type: "integer" } }
      JSON::Validator.validate(integer_array_schema, available_users_cookie)
    end

    def available_users_cookie
      @cookies.signed[COOKIE_NAME]
    end
end
