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
  validates :subdomain, presence: true
  validate :unique_subdomain
  validate :url_safe_subdomain

  def save
    valid? && persist!
  end

  private

    def unique_subdomain
      if Team.where(subdomain: subdomain).exists?
        errors.add(:subdomain, "already in use")
      end
    end

    def url_safe_subdomain
      only_letters_and_numbers = /^[a-zA-Z0-9_-]*$/

      if subdomain && !(subdomain =~ only_letters_and_numbers)
        errors.add(:subdomain, "contains special characters")
      end
    end

    def persist!
      @team = Team.create(name: name, subdomain: subdomain)

      CreateTeamMemberForNewTeam.call(user: user, team: @team)
    end
end
