class Invitations::RegisterController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @register_with_invitation_form = RegisterWithInvitationForm.new
  end

  def create
    @register_with_invitation_form = RegisterWithInvitationForm.new(register_with_invitation_form_params.to_h)

    if @register_with_invitation_form.save
      user = @register_with_invitation_form.user

      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new
    end
  end

  private

    def register_with_invitation_form_params
      params.require(:register_with_invitation_form).permit(:email, :password, :password_confirmation, :invitation_token)
    end
end
