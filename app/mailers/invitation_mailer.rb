class InvitationMailer < ApplicationMailer
  default from: "sp@ces.com"

  def join_team(invitation)
    @invitation = invitation
    @invitation_url = landing_url(invitation_token: @invitation.token)
    mail(to: @invitation.email, subject: "Join #{invitation.team} in Spaces")
  end
end
