class Invitation < ApplicationRecord
  belongs_to :team_member
  has_one :team, through: :team_member

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :token, uniqueness: true, presence: true
  validate :email_one_invitation_per_team

  private

    def email_one_invitation_per_team
      if team.invitations.find_by_email(email)
        errors.add(:email, "already has invitation for team")
      end
    end
end
