class Slack::CreateInvitation
  include Interactor

  attr_reader :team, :user, :slack_user

  def call
    @team = context.team
    @user = context.user
    @slack_user = context.slack_user

    context.invitation = invitation
    context.fail! unless context.invitation.save
  end

  def invitation
    team.invitations.new(user: user, slack_id: slack_user.id,
                         first_name: slack_user.profile.first_name,
                         last_name: slack_user.profile.last_name,
                         email: slack_user.profile.email)
  end

end
