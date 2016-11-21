class GenerateLoginToken

  def self.call(user:)
    authentication_token(user)
  end

  private

    def self.authentication_token(user)
      payload = { user_id: user.id, exp: Time.now.to_i + ENV["AUTH_TOKEN_EXPIRES_IN_SECONDS"].to_i }
      JWT.encode(payload, ENV["COLLAB_SERVICE_JWT_SECRET"], "HS256")
    end
end
