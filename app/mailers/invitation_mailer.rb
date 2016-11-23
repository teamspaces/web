class InvitationMailer < ApplicationMailer

  def join_team(invitation)
    @invitation = invitation
    @invitation_url = landing_url(subdomain: @invitation.team.subdomain, invitation_token: @invitation.token)
    mail(to: @invitation.email, subject: "Join #{invitation.team.name} in Spaces")
  end
end
