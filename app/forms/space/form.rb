class Space::Form
  include ActiveModel::Model
  include ActiveModel::Conversion
  include Virtus.model

  attr_reader :space, :user
  delegate :cached_cover_data, to: :space
  delegate :cover_url, to: :space
  delegate :id, to: :space
  delegate :model_name, to: :space
  delegate :persisted?, to: :space

  attribute :name, String
  attribute :cover
  attribute :team_id
  attribute :access_control_rule, String

  attribute :private_access_control, Boolean
  attribute :team_access_control, Boolean

  validates :name, presence: true
  validates :team_id, presence: true
  validates :cover, attached_image: true
  validates :access_control_rule, presence: true

  def initialize(space:, user: nil, params: {})
    @space = space
    @user = user

    super(@space.attributes)
    super(params)
  end

  def cover=(uploaded_file)
    Space::Cover::AttachUploadedCover.call(space: @space, file: uploaded_file)
  end

  def private_access_control=(_)
    @access_control_rule = Space::AccessControlRules::PRIVATE
  end

  def team_access_control=(_)
    @access_control_rule = Space::AccessControlRules::TEAM
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      @space.assign_attributes(name: name, team_id: team_id, access_control_rule: access_control_rule)
      @space.save
    end
end
