class InvitationDecorator < Draper::Decorator
  delegate_all

  def email_invitation?
    object.email
  end

  def slack_invitation?
    object.slack_user_id
  end

  def already_accepted?
    object.invitee_user_id
  end
end
