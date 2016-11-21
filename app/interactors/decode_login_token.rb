class DecodeLoginToken
  include Interactor

  attr_reader :token

  def call
    @token = context.token

    return context.fail! unless token.present? && valid_authentication_payload?

    context.user = user_encoded_in_payload
  end

  private

    def valid_authentication_payload?
      authentication_payload && user_encoded_in_payload.present?
    end

    def user_encoded_in_payload
      @user_encoded_in_payload ||= User.find_by_id(authentication_payload["user_id"])
    end

    def authentication_payload
      @authentication_payload ||= decode_authentication_payload
    end

    def decode_authentication_payload
      begin
        JWT.decode(token, ENV["JWT_SECRET"])[0]
      rescue JWT::DecodeError
        return nil
      rescue JWT::ExpiredSignature
        return nil
      end
    end
end
