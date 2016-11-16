class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_one :invitee, class_name: "User", foreign_key: "invitee_user_id"

  validates :token, uniqueness: true
  before_create :generate_token

  private

    def generate_token
      self.token = SecureRandom.urlsafe_base64(64)
    end
end
