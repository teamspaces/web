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
  attribute :team_id
  attribute :access_control, Boolean, default: false

  validates :name, presence: true
  validates :team_id, presence: true
  validates :cover, attached_image: true

  def initialize(space:, params: {})
    @space = space

    super(@space.attributes)
    super(params)
  end

  def cover=(uploaded_file)
    Space::Cover::AttachUploadedCover.call(space: @space, file: uploaded_file)
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      @space.assign_attributes(name: name, team_id: team_id, access_control: access_control)
      @space.save
    end
end
