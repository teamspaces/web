class TokenAuthentication::GenerateSignInUrl
  include UrlParameterHelper
  include Interactor

  TOKEN_PARAM_KEY = "auth_token"
  EXPIRES_IN_SECONDS = 60

  def call
    context.token = user_authentication_token(context.user)
    context.url = add_parameter_to_url(context.url, TOKEN_PARAM_KEY, context.token)
  end

  private

    def user_authentication_token(user)
      payload = { user_id: user.id, exp: Time.now.to_i + EXPIRES_IN_SECONDS }
      JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS256")
    end
end
