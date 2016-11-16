class SendInvitationForm
  include Inflorm

  attr_reader :invitation, :to_key

  attribute :team, Team
  attribute :user, User

  attribute :email, String
  attribute :first_name, String
  attribute :last_name, String

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :team, presence: true
  validates :user, presence: true
  validate :email_one_invitation_per_team

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
      @invitation.save

      SendJoinTeamInvitation.call(invitation: @invitation)
    end
end
