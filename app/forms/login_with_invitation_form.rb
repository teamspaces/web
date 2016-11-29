class LoginWithInvitationForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attribute :email, String
  attribute :password, String
  attribute :invitation_token, String

  validates :email, presence: true
  validates :password, presence: true

  validate :email_password_combination
  validates :invitation, presence: true
  validates_with InvitationInviteeEmailValidator

  def user
    @user ||= User.find_for_authentication(email: email)
  end

  def invitation
    @invitation ||= Invitation.find_by(token: invitation_token)
  end

  def save
    valid? && persist!
  end

  def persist!
    AcceptInvitation.call(user: user, invitation: invitation)
  end

 private

  def email_password_combination
    unless user.try(:valid_password?, password)
      self.errors[:base] << I18n.t('devise.failure.invalid', authentication_keys: User.authentication_keys.join(", "))
    end
  end
end
