class InvitationMailer < ApplicationMailer
  default from: "sp@ces.com"

  def join_team(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: "Join #{invitation.team} in Spaces")
  end
end
