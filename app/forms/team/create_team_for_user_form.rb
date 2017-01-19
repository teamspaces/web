class Team::CreateTeamForUserForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :team
  delegate :cached_logo_data, to: :team
  delegate :logo_url, to: :team

  attribute :user, User
  attribute :name, String
  attribute :subdomain, String
  attribute :logo

  validates :user, presence: true
  validates :name, presence: true
  validates :subdomain, presence: true,
                        subdomain: true
  validate :unique_subdomain
  validate :valid_logo

  def initialize(params={})
    @team = Team.new
    super
  end

  def logo=(uploaded_file)
    Team::Logo::AttachUploadedLogo.call(team: @team, file: uploaded_file)
  end

  def save
    valid? && persist!
  end

  private

    def valid_logo
      @team.logo_attacher.errors.each do |message|
        self.errors.add(:logo, message)
      end
      @team.logo_attacher.errors.any?
    end

    def unique_subdomain
      if Team.where(subdomain: subdomain).exists?
        errors.add(:subdomain, :taken)
      end
    end

    def persist!
      @team.assign_attributes(name: name, subdomain: subdomain)
      Team::Logo::AttachGeneratedLogo.call(team: team) unless @team.logo.present?
      @team.save

      CreateTeamMemberForNewTeam.call(user: user, team: @team)
    end
end