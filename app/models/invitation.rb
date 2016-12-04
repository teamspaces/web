class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_one :invitee, class_name: "User", primary_key: "invitee_user_id", foreign_key: "id"

  scope :used, -> { where.not(invitee_user_id: nil) }
  scope :unused, -> { where(invitee_user_id: nil) }

  validates :token, uniqueness: true
  before_create :generate_token

  private

    def generate_token
      self.token = SecureRandom.urlsafe_base64(64)
    end
end
