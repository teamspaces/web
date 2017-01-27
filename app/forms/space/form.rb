class Space::Form
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :space
  delegate :cached_cover_data, to: :space
  delegate :cover_url, to: :space
  delegate :model_name, to: :space
  delegate :persisted?, to: :space

  attribute :name, String
  attribute :cover

  validates :name, presence: true
  validates :team_id, presence: true
  validate :valid_cover

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

    def valid_cover
      @space.cover_attacher.errors.each do |message|
        self.errors.add(:cover, message)
      end
      @team.cover_attacher.errors.any?
    end

    def persist!
      @space.assign_attributes(name: name)
      @space.save
    end
end
