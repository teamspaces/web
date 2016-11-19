class TokenAuthentication::SignInUser
  include UrlParameterHelper
  include Interactor

  TOKEN_PARAM_KEY = "auth_token"

  attr_reader :url, :controller

  def call
    @url = context.url
    @controller = context.controller

    return context.fail! unless valid_authentication_payload?

    controller.sign_in authentication_user
    controller.redirect_to remove_parameter_from_url(url, TOKEN_PARAM_KEY)
  end

  private

    def valid_authentication_payload?
      authentication_payload &&
      authentication_payload["exp"] > Time.now.to_i &&
      authentication_user.present?
    end

    def authentication_user
      @authentication_user ||= User.find_by_id(authentication_payload["user_id"])
    end

    def authentication_payload
      if authentication_token_param.present?
        @authentication_payload ||= begin
          JWT.decode(authentication_token_param, Rails.application.secrets.secret_key_base)[0]
        end
      end
    end

    def authentication_token_param
      @authentication_token_param ||= parameter_value(url, TOKEN_PARAM_KEY)
    end
end
