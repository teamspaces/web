class Invitation::InvitationForm
  include Inflorm

  attr_reader :invitation

  attribute :team, Team
  attribute :user, User
  attribute :invitee, User

  attribute :first_name, String
  attribute :last_name, String
  attribute :email, String
  attribute :token, String


  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :team, presence: true
  validates :user, presence: true
  validate :email_one_invitation_per_team

  def to_key
    nil
  end

  private

    def email_one_invitation_per_team
      if team && team.invitations.find_by_email(email)
        errors.add(:email, "already has invitation for team")
      end
    end

    def persist!
      @invitation = Invitation.new(to_h.except(:team, :user, :invitee))
      @invitation.user = user
      @invitation.team = team
      @invitation.invitee = invitee
      @invitation.save
    end
end
