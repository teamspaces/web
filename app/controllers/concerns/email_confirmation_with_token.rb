module EmailConfirmationWithToken
  extend ActiveSupport::Concern

  included do
    before_action :email_confirmation_with_token?
  end

  def email_confirmation_with_token?
    return unless params[:confirmation_token].present?

    user = User.confirm_by_token(params[:confirmation_token])
    flash[:notice] = user.errors.full_messages.to_sentence unless user.errors.empty?

    params.delete :confirmation_token
    redirect_to request.path, params: params
  end
end
