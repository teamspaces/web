class LoginRegisterFunnel::EmailAddressForm
  include ActiveModel::Model
  

  attr_reader :email

  attribute :email, String

  validates :email, presence: true
  validates_format_of :email, with: Devise::email_regexp, allow_blank: true
end
