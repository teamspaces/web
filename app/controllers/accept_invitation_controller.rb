class AcceptInvitationController < ApplicationController
  include InvitationCookie

  skip_before_action :authenticate_user!

  def new
    invitation = Invitation.find_by(token: params[:invitation_cookie])&.decorate

    return redirect_with_invalid_invitation_notice unless invitation.present?
    return redirect_with_already_accepted_notice if invitation.already_accepted?

    set_invitation_cookie_from_params

    case invitation
      when :slack_invitation? then redirect_to_slack_login_register(invitation)
      when :email_invitation? then redirect_to_email_login_register(invitation)
  end

  private

    def redirect_with_invalid_invitation_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_does_not_exist")
    end

    def redirect_with_already_accepted_notice
      redirect_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), notice: t("invitation_already_accepted")
    end

    def redirect_to_slack_login_register(invitation)
      #email checken ne
    end

    def redirect_to_email_login_register(invitation)
      #email checken
    end
end
