class Team::Form
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :team
  delegate :cached_logo_data, to: :team
  delegate :logo_url, to: :team
  delegate :model_name, to: :team
  delegate :persisted?, to: :team

  attribute :name, String
  attribute :subdomain, String
  attribute :logo

  validates :name, presence: true
  validates :subdomain, presence: true,
                        subdomain: true
  validate :unique_subdomain
  validate :valid_logo

  def initialize(team: Team.new, params: {})
    @team = team

    super(team.attributes)
    super(params)
  end

  def logo=(file)
    Team::Logo::AttachUploadedLogo.call(team: @team, file: file)
  end

  def save
    valid? && persist!
  end

  private

    def unique_subdomain
      if Team.where(subdomain: subdomain).where.not(id: team.id).exists?
        errors.add(:subdomain, :taken)
      end
    end

    def valid_logo
      @team.logo_attacher.errors.each do |message|
        self.errors.add(:logo, message)
      end
      @team.logo_attacher.errors.any?
    end

    def persist!
      @team.assign_attributes(name: name, subdomain: subdomain)
      #has_generated_avatar_and_name_changed?
      Team::Logo::AttachGeneratedLogo.call(team: team) unless @team.logo.present?
      @team.save
    end
end
