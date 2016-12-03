class Invitation::CreateSlackInvitation
  include Interactor

  attr_reader :user, :team, :slack_profile

  def call
    @user = context.user
    @team = context.team
    @slack_profile = context.slack_profile

    slack_invitation = build_slack_invitation
    if slack_invitation.save
      context.slack_invitation = slack_invitation
    else
      context.fail!
    end
  end

  def build_slack_invitation
    Invitation.new(user: user,
                   team: team,
                   first_name: slack_profile.first_name,
                   last_name: slack_profile.last_name,
                   email: slack_profile.email,
                   slack_user_id: slack_profile.user_id)
  end
end
