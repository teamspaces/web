class Invitation < ApplicationRecord
  belongs_to :team_member
  has_one :team, through: :team_member

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :token, uniqueness: true
  validate :email_one_invitation_per_team

  before_create :generate_token

  private

    def email_one_invitation_per_team
      if team.invitations.find_by_email(email)
        errors.add(:email, "already has invitation for team")
      end
    end

    def generate_token
      self.token = Digest::SHA1.hexdigest([self.team_member_id, Time.now, rand].join)
    end
end
