class CreateTeamForUserForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :team

  attribute :user, User
  attribute :name, String

  validates :user, presence: true
  validates :name, presence: true
  validate :unique_team_name
  validate :url_safe_team_name

  def save
    valid? && persist!
  end

  private

    def url_safe_team_name
      only_letters_and_numbers = /^[a-zA-Z0-9_-]*$/

      if name && !(name =~ only_letters_and_numbers)
        errors.add(:name, "has special characters")
      end
    end

    def unique_team_name
      if Team.where(name: name).exists?
        errors.add(:name, "name already in use")
      end
    end

    def persist!
      @team = Team.create(name: name)

      CreateTeamMemberForNewTeam.call(user: user, team: @team)
    end
end
