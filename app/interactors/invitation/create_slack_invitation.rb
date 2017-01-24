class Invitation::CreateSlackInvitation
  include Interactor

  def call
    context.invitation = build_slack_invitation

    context.fail! unless context.invitation.save
  end

  private
    def build_slack_invitation
      Invitation.new(invited_by_user: context.invited_by_user,
                     team: context.team,
                     first_name: context.first_name,
                     last_name: context.last_name,
                     email: context.email,
                     slack_user_id: context.slack_user_id)
    end
end
