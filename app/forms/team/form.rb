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
  validates :logo, attached_image: true

  def initialize(team: Team.new, attributes: {})
    @team = team

    super(team.attributes)
    super(attributes)
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

    def has_generated_logo_and_name_changed?
       Image.new(@team.logo).generated? && @team.name_changed?
    end

    def persist!
      @team.assign_attributes(name: name, subdomain: subdomain)

      if @team.logo.blank? || has_generated_logo_and_name_changed?
        Team::Logo::AttachGeneratedLogo.call(team: team)
      end

      @team.save
    end
end
