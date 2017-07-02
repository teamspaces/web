class SendInvitationForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  

  attr_reader :invitation

  delegate :model_name, to: Invitation

  attribute :team, Team
  attribute :space, Space
  attribute :invited_by_user, User

  attribute :email, String
  attribute :first_name, String
  attribute :last_name, String

  validates_format_of :email, with: Devise::email_regexp
  validates :email, presence: true
  validates :team, presence: true
  validates :invited_by_user, presence: true
  validate :email_one_invitation_per_team

  def initialize(team: nil, space: nil, invited_by_user: nil, attributes: {})
    @team = team
    @space = space
    @invited_by_user = invited_by_user

    super(attributes)
  end

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
                                      first_name: first_name, last_name: last_name, space: space)
    end

    def send!
      Invitation::Send.call(invitation: @invitation)
    end
end
