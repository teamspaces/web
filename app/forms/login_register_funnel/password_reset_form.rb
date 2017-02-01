class LoginRegisterFunnel::PasswordResetForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :email, :user

  attribute :email, String

  validates :email, presence: true
  validate :validate_user_email, if: :email

  private

    def validate_user_email
      @user = user_allowed_for_email_authentication

      unless @user
        not_email_user = user_not_allowed_for_email_authentication

        if not_email_user
          errors.add(:email, "please sign up with ...")
        else
          errors.add(:email, "no user found with that email")
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
