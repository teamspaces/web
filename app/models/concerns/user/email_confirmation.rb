class User
  module EmailConfirmation

    def email_confirmation_required?
      confirmation_required? || pending_reconfirmation?
    end

    def main_email_unconfirmed?
      confirmed_at.nil? && unconfirmed_email.nil?
    end

    def confirmation_required?
      allow_email_login && super
    end

    def postpone_email_change?
      allow_email_login && !main_email_unconfirmed? && super
    end

    def reconfirmation_required?
      allow_email_login && super
    end

  end
end
