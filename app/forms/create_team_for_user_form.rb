class CreateTeamForUserForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :team

  attribute :user, User
  attribute :name, String
  attribute :subdomain, String

  validates :user, presence: true
  validates :name, presence: true
  validates :subdomain, presence: true,
                        subdomain: true
  validate :unique_subdomain

  def subdomain=(val)
    @subdomain = val&.downcase
  end

  def save
    valid? && persist!
  end

  private

    def unique_subdomain
      if Team.where(subdomain: subdomain).exists?
        errors.add(:subdomain, :taken)
      end
    end

    def persist!
      @team = Team.create(name: name, subdomain: subdomain)

      CreateTeamMemberForNewTeam.call(user: user, team: @team)
    end
end
