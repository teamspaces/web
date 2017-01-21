class User
  module EmailConfirmation

    def email_confirmation_required?
      confirmation_required? || pending_reconfirmation?
    end

    def email_confirmed_once?
      confirmed? && !pending_reconfirmation?
    end

    def confirmation_required?
      allow_email_login && super
    end

    def postpone_email_change?
      if allow_email_login
        if unconfirmed_email.present?
          return true
        else
          return email_confirmed_once? && super
        end
      else
        false
      end
    end

    def reconfirmation_required?
      allow_email_login && super
    end

  end
end
