class User
  module EmailConfirmable
    extend ActiveSupport::Concern

    included do
      devise :confirmable
      after_update :send_new_on_create_confirmation_instructions, if: :email_changed_before_ever_confirmed?
    end

    def email_confirmation_required?
      confirmation_required? || pending_reconfirmation?
    end

    def email_confirmed_ever?
      !(confirmed_at.nil? && unconfirmed_email.nil?)
    end

    def email_changed_before_ever_confirmed?
      allow_email_login && email_changed? && !email_confirmed_ever?
    end

    def send_new_on_create_confirmation_instructions
      reload

      self.confirmation_token = nil
      generate_confirmation_token!

      send_on_create_confirmation_instructions
    end

    # overwrite devise confirmable
    def confirmation_required?
      allow_email_login && super
    end

    def postpone_email_change?
      allow_email_login && email_confirmed_ever? && super
    end

    def reconfirmation_required?
      allow_email_login && super
    end
  end
end
