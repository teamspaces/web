class Slack::AcceptInvitation
  include Interactor

  attr_reader :invitation_token, :user, :slack_identity

  def call
    @invitation_token = context.invitation_token
    @user = context.user
    @slack_identity = context.slack_identity

    if invitation && invitation_matches_slack_identity?
      AcceptInvitation.call(user: user, invitation: invitation)
    else
      context.fail!
    end
  end

  def invitation_matches_slack_identity?
    if invitation.slack_id
      invitation.slack_id == slack_identity.user.id
    else
      invitation.email == slack_identity.user.email
    end
  end

  def invitation
    @invitation ||= Invitation.find(invitation_token)
  end
end
