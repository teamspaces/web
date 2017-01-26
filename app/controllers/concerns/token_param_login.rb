module TokenParamLogin
  extend ActiveSupport::Concern

  included do
    before_action :token_authentication_requested?
  end

  def token_authentication_requested?
    return unless params[:auth_token].present?

    result = DecodeLoginToken.call(token: params[:auth_token])

    sign_in(result.user) if result.success?

    debugger

    params.delete :auth_token
    redirect_to request.path, params: params
  end
end
