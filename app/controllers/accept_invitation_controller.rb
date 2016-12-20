class AcceptInvitationController < ApplicationController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo
  include InvitationCookie

  skip_before_action :authenticate_user!

  def new
    invitation = Invitation.find_by(token: params[:invitation_token])&.decorate

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_accepted_notice if invitation.already_accepted?

    set_invitation_cookie_from_params

    redirect_to case
      when invitation.slack_invitation? then slack_register_path
      when invitation.email_invitation? then email_login_or_register_path(invitation)
    end
  end

  private

    def redirect_with_invalid_invitation_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_does_not_exist")
    end

    def redirect_with_already_accepted_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_already_accepted")
    end

    def email_login_or_register_path(invitation)
      in_login_register_funnel_provided_email_address = invitation.email

      case
        when invitation.invitee_is_registered_email_user? then new_email_login_path
        else new_email_register_path
      end
    end
end
