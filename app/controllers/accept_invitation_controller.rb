class AcceptInvitationController < ApplicationController
  include InvitationCookie

  skip_before_action :authenticate_user!
  before_action :set_invitation_cookie_from_params


  def new
    invitation = Invitation.find_by(token: invitation_cookie)&.decorate

    if invitation.present?
      if invitation.already_accepted?

      if invitation.slack_invitation?

      elsif invitation.email_invitation?

      end
    else

    end
  end
end
