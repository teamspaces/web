class LoginRegisterFunnel::AcceptInvitationController < LoginRegisterFunnelController

  def new
    invitation = Invitation.find_by(token: params[:invitation_token])&.decorate

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_accepted_notice if invitation.already_accepted?

    set_invitation_token_cookie(invitation.token)

    redirect_to case
      when invitation.slack_invitation? then slack_register_path
      when invitation.email_invitation? then email_login_or_register_path(invitation)
    end
  end

  private

    def redirect_with_invalid_invitation_notice
      redirect_to landing_path, notice: t("invitation_does_not_exist")
    end

    def redirect_with_already_accepted_notice
      redirect_to landing_path, notice: t("invitation_already_accepted")
    end

    def email_login_or_register_path(invitation)
      set_users_reviewed_email_address(invitation.email)

      case
        when invitation.accepting_user_is_already_registered_using_email? then new_email_login_path
        else new_email_register_path
      end
    end
end
