class Invitation < ApplicationRecord
  belongs_to :team

  has_one :invited_by_user, class_name: "User", foreign_key: "invited_by_user_id", primary_key: "id"
  has_one :invited_user, class_name: "User", foreign_key: "invited_user_id", primary_key: "id"

  scope :used, -> { where.not(invited_user_id: nil) }
  scope :unused, -> { where(invited_user_id: nil) }

  validates :token, uniqueness: true
  before_create :generate_token

  def slack_invitation?
    slack_user_id.present?
  end

  def email_invitation?
    email.present? && !slack_invitation?
  end

  def used?
    invited_user.present?
  end

  def invited_user_is_registered_email_user?
    email.present? && User.find_for_authentication(email: email).present?
  end

  private

    def generate_token
      self.token = SecureRandom.urlsafe_base64(64)
    end
end
