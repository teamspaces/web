class InvitationMailer < ApplicationMailer
  default from: "s0544845@htw-berlin.de"

  def join_team(invitation)
    @invitation = invitation
    @url = "http://localhost:5510/?invitation_token=#{@invitation.token}"
    mail(to: @invitation.email, subject: 'Join Team')
  end

  def join_spaces(invitation)
    @invitation = invitation
    @url = "http://localhost:5510/?invitation_token=#{@invitation.token}"
    mail(to: @invitation.email, subject: 'Join Spaces')
  end
end
