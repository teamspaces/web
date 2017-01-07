class LoginRegisterFunnel::AcceptInvitationController < LoginRegisterFunnelController

  def new
    invitation = Invitation.find_by(token: params[:invitation_token])&.decorate

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_used_notice if invitation.already_accepted?

    LoginRegisterFunnel::InvitationCookie.new(cookies).save(invitation)

    redirect_to case
      when invitation.slack_invitation? then slack_register_path
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
        when invitation.accepting_user_is_already_registered_using_email? then new_email_login_path
        else new_email_register_path
      end
    end
end
