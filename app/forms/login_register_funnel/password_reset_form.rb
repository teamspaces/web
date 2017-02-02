class LoginRegisterFunnel::PasswordResetForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :email, :user

  attribute :email, String

  validates :email, presence: true
  validate :validate_user_email, if: :email


  def send_reset_password_instructions
    valid? && user.send_reset_password_instructions
  end

  private

    def validate_user_email
      @user = user_allowed_for_email_authentication

      unless @user
        user_not_allowed_to_authenticate_with_email = user_not_allowed_for_email_authentication

        if user_not_allowed_to_authenticate_with_email
          errors.add(:email, t("user.password_reset.email.errors.not_allowed_for_email_authentication"))
        else
          errors.add(:email, t("user.password_reset.email.errors.not_found"))
        end
      end
    end

    def user_allowed_for_email_authentication
      User.find_for_authentication(email: email)
    end

    def user_not_allowed_for_email_authentication
      User.find_by(email: email, allow_email_login: false)
    end
end
