class LoginRegisterFunnel::EmailRegisterForm
  include FormHelpers::Errors
  include ActiveModel::Model
  include Virtus.model

  attr_reader :email

  attribute :email, String

  attribute :first_name, String
  attribute :last_name, String

  attribute :password, String
  attribute :password_confirmation, String

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :password, presence: true
  validates :password_confirmation, presence: true

  validate :validate_user

  def user
    @user ||= User.new(email: email,
                       password: password,
                       password_confirmation: password_confirmation,
                       first_name: first_name,
                       last_name: last_name,
                       allow_email_login: true)
  end

  def save
    valid? && attach_avatar && persist!
  end

  def attach_avatar
    User::Avatar::AttachGeneratedAvatar.call(user: user).success?
  end

  def persist!
    user.save
    user.send_confirmation_instructions
  end

 private

  def validate_user
    add_errors_from(user)

    user.valid?
  end
end
