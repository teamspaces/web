class InvitationDecorator < Draper::Decorator
  delegate_all

  def slack_invitation?
    object.slack_user_id.present?
  end

  def email_invitation?
    object.email.present? && !slack_invitation?
  end

  def already_accepted?
    object.invitee_user_id.present?
  end

  def accepting_user_is_already_registered_using_email?
    object.email.present? && User.find_for_authentication(email: object.email).present?
  end
end
