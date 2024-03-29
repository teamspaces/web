class LoginRegisterFunnel::AcceptInvitationController < LoginRegisterFunnel::BaseController

  def new
    invitation = Invitation.find_by(token: params[:invitation_token])

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_used_notice if invitation.used?

    LoginRegisterFunnel::BaseController::InvitationCookie.new(cookies).save(invitation)

    redirect_to case
      when invitation.slack_invitation? then user_slack_omniauth_authorize_url(state: :register)
      when invitation.email_invitation? then email_login_or_register_path(invitation)
    end
  end

  private

    def redirect_with_invalid_invitation_notice
      redirect_to root_path, notice: t("invitation.errors.does_not_exist")
    end

    def redirect_with_already_used_notice
      redirect_to root_path, notice: t("invitation.errors.already_used")
    end

    def email_login_or_register_path(invitation)
      shared_user_info.reviewed_email_address = invitation.email

      case
        when invitation.invited_user_is_registered_email_user? then new_email_login_path
        else new_email_register_path
      end
    end
end
