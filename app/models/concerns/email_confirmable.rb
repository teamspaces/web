module EmailConfirmable
  extend ActiveSupport::Concern

  def email_confirmation_required?
    allow_email_login && (!confirmed? || pending_reconfirmation?)
  end

  def email_confirmed_ever?
    !(confirmed_at.nil? && unconfirmed_email.nil?)
  end
end

