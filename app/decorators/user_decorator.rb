class UserDecorator < Draper::Decorator
  delegate_all

  def login_using_email?
    object.allow_email_login
  end

  def login_using_slack?
    object.authentications.find_by(provider: :slack).present?
  end
end
