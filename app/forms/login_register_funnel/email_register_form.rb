class LoginRegisterFunnel::EmailRegisterForm
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

  validates :email, presence: true
  validates_format_of :email, with: Devise::email_regexp, allow_blank: true

  validate :validate_user_object

  def user
    @user ||= User.new(email: email,
                       password: password,
                       password_confirmation: password_confirmation,
                       first_name: first_name,
                       last_name: last_name)
  end

  def save
    valid? && persist!
  end

  def persist!
    user.save
  end

 private

  def validate_user_object
    user.valid?
    user.errors.each do |attribute, message|
      self.errors.add(attribute, message)
    end
    user.valid?
  end
end