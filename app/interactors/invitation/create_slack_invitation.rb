class Invitation::CreateSlackInvitation
  include Interactor

  attr_reader :user, :team, :first_name, :last_name, :email, :slack_user_id

  def call
    @user = context.user
    @team = context.team

    @first_name = context.first_name
    @last_name = context.last_name
    @email = context.email
    @slack_user_id = context.slack_user_id

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
                   first_name: first_name,
                   last_name: last_name,
                   email: email,
                   slack_user_id: slack_user_id)
  end
end
