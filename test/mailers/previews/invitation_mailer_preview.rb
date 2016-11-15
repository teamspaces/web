# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def join_team_preview
    InvitationMailer.join_team(Invitation.first)
  end
end
