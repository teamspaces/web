class Invitation::Slack::Create
  include Interactor

  def call
    context.invitation_attributes.each { |key, value| context[key] = value }

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
                     invited_slack_user_uid: context.invited_slack_user_uid)
    end
end
