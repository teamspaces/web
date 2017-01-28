class UserDecorator < Draper::Decorator
  delegate_all

  def login_using_email?
    object.allow_email_login
  end

  def login_using_slack?
    object.authentications.find_by(provider: :slack).present?
  end

  def email_to_confirm
    if object.email_confirmation_required?
      object.unconfirmed_email || object.email
    end
  end
end
