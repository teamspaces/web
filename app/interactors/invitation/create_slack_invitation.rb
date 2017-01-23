class Invitation::CreateSlackInvitation
  include Interactor

  def call
    invitation = build_slack_invitation

    if invitation.save
      context.invitation = invitation
    else
      context.fail!
    end
  end

  private
    def build_slack_invitation
      Invitation.new(team: context.team,
                     first_name: context.first_name,
                     last_name: context.last_name,
                     email: context.email,
                     slack_user_id: context.slack_user_id)
    end
end
