class Invitation < ApplicationRecord
  acts_as_paranoid

  belongs_to :team

  belongs_to :invited_by_user, class_name: "User", foreign_key: "invited_by_user_id", primary_key: "id"
  belongs_to :invited_user, class_name: "User", foreign_key: "invited_user_id", primary_key: "id", optional: true

  scope :used, -> { where.not(invited_user_id: nil) }
  scope :unused, -> { where(invited_user_id: nil) }

  validates :token, uniqueness: true
  before_create :generate_token

  def slack_invitation?
    invited_slack_user_uid.present?
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
