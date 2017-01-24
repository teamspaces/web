class Team::UpdateTeamForm
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :team
  delegate :cached_logo_data, to: :team
  delegate :logo_url, to: :team
  delegate :model_name, to: :team
  delegate :persisted?, to: :team

  attribute :name, String
  attribute :logo
  attribute :allowed_email_domains, String

  validates :name, presence: true
  validate :valid_logo
  validate :valid_email_domains

  def initialize(team, params={})
    @team = team

    super(@team.attributes)
    super(params)
  end

  def allowed_email_domains
    @allowed_email_domains.join(", ")
  end

  def allowed_email_domains=(email_domains)
    @allowed_email_domains = if email_domains.kind_of?(Array)
      email_domains
    else
      email_domains.split(",").map(&:strip) if email_domains
    end
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

    def valid_email_domains
      email_domains.all? { |domain| domain.include? "@" }
    end

    def persist!
      @team.assign_attributes(name: name, allowed_email_domains: @allowed_email_domains)
      @team.save
    end

end
