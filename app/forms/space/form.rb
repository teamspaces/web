class Space::Form
  include ActiveModel::Model
  include ActiveModel::Conversion
  

  attr_reader :space, :user
  delegate :cached_cover_data, to: :space
  delegate :cover_url, to: :space
  delegate :id, to: :space
  delegate :model_name, to: :space
  delegate :persisted?, to: :space

  attribute :name, String
  attribute :cover
  attribute :team_id
  attribute :access_control

  validates :name, presence: true
  validates :team_id, presence: true
  validates :cover, attached_image: true
  validates_inclusion_of :access_control, in: [Space::AccessControl::TEAM,
                                               Space::AccessControl::PRIVATE]

  def initialize(space:, user: nil, attributes: {})
    @space = space
    @user = user

    super(@space.attributes)
    super(attributes)
  end

  def cover=(uploaded_file)
    Space::Cover::AttachUploadedCover.call(space: @space, file: uploaded_file)
  end

  def save
    valid? && persist! && apply_access_control!
  end

  private

    def persist!
      @space.assign_attributes(name: name, team_id: team_id, access_control: access_control)
      @space.save
    end

    def apply_access_control!
      Space::AccessControl::Apply.call(user: @user, space: @space)
    end
end
