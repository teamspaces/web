class GenerateLoginToken

  EXPIRES_IN_SECONDS=2

  def self.call(user:)
    authentication_token(user)
  end

  private

    def self.authentication_token(user)
      payload = { user_id: user.id, exp: Time.now.to_i + GenerateLoginToken::EXPIRES_IN_SECONDS }
      JWT.encode(payload, ENV["USER_AUTH_JWT_SECRET"], "HS256")
    end
end
