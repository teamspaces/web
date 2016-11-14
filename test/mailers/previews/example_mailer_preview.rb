# Preview all emails at http://localhost:3000/rails/mailers/example_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def join_spaces_preview
    InvitationMailer.join_spaces(Invitation.last)
  end
end
