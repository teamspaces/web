class Invitation < ApplicationRecord
  belongs_to :team_member
  has_one :team, through: :team_member

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :team_member, presence: true
  validates :token, uniqueness: true
  validate :unique_email_team_combination

  before_create :generate_token
  after_create :send_invitation_mail


  def send_invitation_mail
    if recipient_registered?
      InvitationMailer.join_team(self).deliver
    else
      InvitationMailer.join_spaces(self).deliver
    end
  end

  def unique_email_team_combination
    if team.invitations.find_by_email(email)
      errors.add(:email, "already invited")
    end
  end

  private

    def recipient_registered?
      User.exists?(email: self.email)
    end

    def generate_token
      self.token = Digest::SHA1.hexdigest([self.team_member_id, Time.now, rand].join)
    end
end
