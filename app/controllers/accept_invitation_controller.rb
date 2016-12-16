class AcceptInvitationController < ApplicationController
  include LoginRegisterFunnel::PrecedingFunnelStepsInfo
  include InvitationCookie

  skip_before_action :authenticate_user!

  def new
    invitation = Invitation.find_by(token: params[:invitation_token])&.decorate

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_accepted_notice if invitation.already_accepted?

    set_invitation_cookie_from_params

    invitation.switch(
      slack_invitation?: -> { redirect_to slack_register_path },
      email_invitation?: -> { redirect_to_email_login_register(invitation) })
  end

  private

    def redirect_with_invalid_invitation_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_does_not_exist")
    end

    def redirect_with_already_accepted_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_already_accepted")
    end

    def redirect_to_email_login_register(invitation)
      set_in_login_register_funnel_provided_email(invitation.email)

      redirect_to case
        when invitation.invitee_is_registered_email_user? then new_email_login_path
        else new_email_register_path
      end
    end
end
