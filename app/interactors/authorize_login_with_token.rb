class AuthorizeLoginWithToken
  include Interactor

  attr_reader :auth_token

  def call
    @auth_token = context.auth_token

    return context.fail! unless valid_authentication_payload?

    context.user = user_encoded_in_payload
  end

  private

    def valid_authentication_payload?
      authentication_payload &&
      authentication_payload["exp"] > Time.now.to_i &&
      user_encoded_in_payload.present?
    end

    def user_encoded_in_payload
      @user_encoded_in_payload ||= User.find_by_id(authentication_payload["user_id"])
    end

    def authentication_payload
      if auth_token.present?
        @authentication_payload ||= begin
          JWT.decode(auth_token, ENV["COLLAB_SERVICE_JWT_SECRET"])[0]
        end
      end
    end
end
