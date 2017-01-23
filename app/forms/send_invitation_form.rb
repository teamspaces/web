class SendInvitationForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :invitation

  attribute :team, Team
  attribute :invited_by_user, User

  attribute :email, String
  attribute :first_name, String
  attribute :last_name, String

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :team, presence: true
  validates :invited_by_user, presence: true
  validate :email_one_invitation_per_team

  def save
    valid? && persist! && send!
  end

  private

    def email_one_invitation_per_team
      if team && team.invitations.find_by_email(email)
        errors.add(:email, "already has invitation for team")
      end
    end

    def persist!
      @invitation = Invitation.create(email: email, team: team, invited_by_user: invited_by_user,
                                      first_name: first_name, last_name: last_name)
    end

    def send!
      Invitation::SendInvitation.call(invitation: @invitation)
    end
end
