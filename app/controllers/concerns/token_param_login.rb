module TokenParamLogin
  extend ActiveSupport::Concern

  included do
    before_action :token_authentication_requested?
  end

  def token_authentication_requested?
    result = DecodeLoginToken.call(token: params[:auth_token])

    sign_in(result.user) if result.success?
  end
end
