class InvitationMailer < ApplicationMailer

  def join_team(invitation)
    @invitation = invitation
    @invitation_url = accept_invitation_url(@invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

    mail(to: @invitation.email, subject: "Join #{invitation.team.name} in Spaces")
  end
end
