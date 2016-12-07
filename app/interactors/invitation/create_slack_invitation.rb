class Invitation::CreateSlackInvitation
  include Interactor

  attr_reader :user, :team, :slack_user

  def call
    @user = context.user
    @team = context.team

    result = Slack::FetchUserInfo.call(team: team, user_id: context.slack_user_id)
    context.fail! unless result.success?

    @slack_user = result.slack_user

    slack_invitation = build_slack_invitation
    if slack_invitation.save
      context.invitation = slack_invitation
    else
      context.fail!
    end
  end


  def build_slack_invitation
    Invitation.new(user: user,
                   team: team,
                   first_name: slack_user.profile.first_name,
                   last_name: slack_user.profile.last_name,
                   email: slack_user.profile.email,
                   slack_user_id: slack_user.id)
  end
end
