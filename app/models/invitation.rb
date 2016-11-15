class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_one :invitee, class_name: "User", foreign_key: "invitee_user_id"

  validates_format_of :email, with: Devise::email_regexp
  validates :team, presence: true
  validates :user, presence: true
  validates :email, presence: true
  validates :token, uniqueness: true
  validate :email_one_invitation_per_team

  before_create :generate_token

  private

    def email_one_invitation_per_team
      if team && team.invitations.find_by_email(email)
        errors.add(:email, "already has invitation for team")
      end
    end

    def generate_token
      self.token = SecureRandom.urlsafe_base64(64)
    end
end
