class LoginRegisterFunnel::EmailLoginForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :email

  attribute :email, String
  attribute :password, String

  validates :email, presence: true
  validates :password, presence: true
  validate :email_password_combination

  def user
    @user ||= User.find_by(email: email)
  end

  private

    def email_password_combination
      unless user.try(:valid_password?, password)
        self.errors[:base] << I18n.t('users.login.errors.wrong_password')
      end
    end
end
