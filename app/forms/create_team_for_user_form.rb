class CreateTeamForUserForm
  include Inflorm

  attr_reader :team, :to_key

  attribute :user, User
  attribute :name, String

  validates :user, presence: true
  validates :name, presence: true
  validate :unique_team_name
  validate :url_safe_team_name

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
