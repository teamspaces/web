class AuthorizeLoginWithToken
  include UrlParameterHelper
  include Interactor

  attr_reader :url, :controller

  def call
    @url = context.url

    return context.fail! unless valid_authentication_payload?

    context.user = user_encoded_in_payload
    context.url = url_without_token_param
  end

  private

    def url_without_token_param
       remove_parameter_from_url(@url, ENV["AUTH_TOKEN_PARAM_KEY"])
    end

    def valid_authentication_payload?
      authentication_payload &&
      authentication_payload["exp"] > Time.now.to_i &&
      user_encoded_in_payload.present?
    end

    def user_encoded_in_payload
      @user_encoded_in_payload ||= User.find_by_id(authentication_payload["user_id"])
    end

    def authentication_payload
      if authentication_token_param.present?
        @authentication_payload ||= begin
          JWT.decode(authentication_token_param, ENV["COLLAB_SERVICE_JWT_SECRET"])[0]
        end
      end
    end

    def authentication_token_param
      @authentication_token_param ||= parameter_value(url, ENV["AUTH_TOKEN_PARAM_KEY"])
    end
end
