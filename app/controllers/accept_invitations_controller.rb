class AcceptInvitationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @invitation = Invitation.find_by(token: params[:token])
  end

  def new_login
    @login_with_invitation_form = LoginWithInvitationForm.new
  end

  def create_login
    @login_with_invitation_form = LoginWithInvitationForm.new(login_with_invitation_form_params)

    if @login_with_invitation_form.save
      user = @login_with_invitation_form.user
      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new_login
    end
  end

  def new_register
    @register_with_invitation_form = RegisterWithInvitationForm.new
  end

  def create_register
    @register_with_invitation_form = RegisterWithInvitationForm.new(register_with_invitation_form_params)

    if @register_with_invitation_form.save
      user = @register_with_invitation_form.user
      sign_in user
      redirect_to after_sign_in_path_for user
    else
      render :new_register
    end
  end

  private

    def login_with_invitation_form_params
      params.require(:login_with_invitation_form).permit(:email, :password, :invitation_token)
    end

    def register_with_invitation_form_params
      params.require(:register_with_invitation_form).permit(:email, :password, :password_confirmation, :invitation_token)
    end
end
