class Space::Form
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :space
  delegate :cached_cover_data, to: :space
  delegate :cover_url, to: :space
  delegate :id, to: :space
  delegate :model_name, to: :space
  delegate :persisted?, to: :space

  attribute :name, String
  attribute :cover
  attribute :team, Team

  validates :name, presence: true
  validates :team, presence: true
  validates :cover, attached_image: true

  def initialize(space: Space.new, team: nil, attributes: {})
    @space = space
    @team = team

    super(@space.attributes)
    super(attributes)
  end

  def cover=(uploaded_file)
    Space::Cover::AttachUploadedCover.call(space: @space, file: uploaded_file)
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      @space.assign_attributes(name: name, team: team)
      @space.save
    end
end
