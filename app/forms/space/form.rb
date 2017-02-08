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
  attribute :access_control, Boolean, default: false

  validates :name, presence: true
  validates :team_id, presence: true
  validates :cover, attached_image: true

  def initialize(space:, user: nil, params: {})
    @space = space
    @user = user

    super(@space.attributes)
    super(params)
  end

  def cover=(uploaded_file)
    Space::Cover::AttachUploadedCover.call(space: @space, file: uploaded_file)
  end

  def save
    valid? && persist!
    #&& regulate_access_control!
  end

  private

    def persist!
      @space.assign_attributes(name: name, team_id: team_id)
      #@space.assign_attributes(name: name, team_id: team_id, access_control: access_control)
      @space.save
    end

   # def regulate_access_control!
   #   if @space.access_control
   #     Space::AccessControl::Add.call(space: @space, initiating_user: user)
   #   else
   #     Space::AccessControl::Remove.call(space: @space)
   #   end
   # end
end
