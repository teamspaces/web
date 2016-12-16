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

  def invitee_is_registered_email_user?
    User.find_by(email: object.email, allow_email_login: true)
  end
end
