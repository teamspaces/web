class TeamInvitation::Send
  include Interactor

  def call
    invitation = context.invitation

    TeamInvitation::SendMail.call(invitation: invitation) if invitation.email
    SlackTeamInvitationMailer.perform_async(invitation.id) if invitation.slack_user_id
  end
end
