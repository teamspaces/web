class RegisterWithInvitationForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attribute :email, String
  attribute :password, String
  attribute :password_confirmation, String
  attribute :invitation_token, String

  validate :validate_user_object
  validates :invitation, presence: true
  validates_with InvitationEmailValidator

  def user
    @user ||= User.new(email: email, password: password, password_confirmation: password_confirmation)
  end

  def invitation
    @invitation ||= Invitation.find_by(token: invitation_token)
  end

  def save
    valid? && persist!
  end

  def persist!
    user.save
    AcceptInvitation.call(user: user, invitation: invitation)
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
