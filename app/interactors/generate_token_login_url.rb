class GenerateTokenLoginUrl
  include UrlParameterHelper
  include Interactor

  def call
    @user = context.user
    @url = context.url

    context.url = url_with_authentication_token_param
  end

  private

    def url_with_authentication_token_param
      token = user_authentication_token
      add_parameter_to_url(@url, ENV["AUTH_TOKEN_PARAM_KEY"], token)
    end

    def user_authentication_token
      payload = { user_id: @user.id, exp: Time.now.to_i + ENV["AUTH_TOKEN_EXPIRES_IN_SECONDS"].to_i }
      JWT.encode(payload, ENV["COLLAB_SERVICE_JWT_SECRET"], "HS256")
    end
end
