class InvitationDecorator < Draper::Decorator
  delegate_all

  def email_invitation?
    invitee_email_kown? and not slack_invitation?
  end

  def slack_invitation?
    object.slack_user_id.present?
  end

  def already_accepted?
    object.invitee_user_id.present?
  end

  def invitee_email_kown?
    object.email.present?
  end

  def invitee_is_registered_email_user?
    object.email and User.find_by(email: object.email, allow_email_login: true).present?
  end
end
