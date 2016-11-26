class Invitations::LoginController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @login_with_invitation_form = LoginWithInvitationForm.new
  end

  def create
    @login_with_invitation_form = LoginWithInvitationForm.new(login_with_invitation_form_params)

    if @login_with_invitation_form.save
      user = @login_with_invitation_form.user
      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new_login
    end
  end

  private

    def login_with_invitation_form_params
      params.require(:login_with_invitation_form).permit(:email, :password, :invitation_token)
    end
end
