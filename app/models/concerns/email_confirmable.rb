module EmailConfirmable
  extend ActiveSupport::Concern

  included do
    after_update :generate_new_confirmation_token, if: :email_to_confirm_changed?
  end

  def email_to_confirm_changed?
    allow_email_login && (email_changed? || unconfirmed_email_changed?)
  end

  def confirmation_instructions_sent?
    self.confirmation_sent_at.present?
  end

  def email_confirmation_required?
    confirmation_required? || pending_reconfirmation?
  end

  def generate_new_confirmation_token
    reload

    self.confirmation_token = nil
    generate_confirmation_token!
  end

  # overwrite devise confirmable
  def generate_confirmation_token
    super
    self.confirmation_sent_at = nil
    true
  end

  def confirmation_required?
    allow_email_login && super
  end

  def postpone_email_change?
    allow_email_login && email_confirmed_ever? && super
  end

  def email_confirmed_ever?
    !(confirmed_at.nil? && unconfirmed_email.nil?)
  end

  def reconfirmation_required?
    allow_email_login && super
  end
end

