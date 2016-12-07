class SlackTeamInvitationMailer
  include Sidekiq::Worker

  def perform(invitation_id)
    invitation = Invitation.find(invitation_id)

    TeamInvitation::SendSlack.call(invitation: invitation)
  end
end
