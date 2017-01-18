class User::UpdateSettingsForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :user
  delegate :cached_avatar_data, to: :user
  delegate :avatar_url, to: :user
  delegate :model_name, to: :user
  delegate :persisted?, to: :user

  attribute :email, String
  attribute :first_name, String
  attribute :last_name, String
  attribute :password, String
  attribute :password_confirmation, String
  attribute :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :validate_user

  def initialize(user, params={})
    @user = user

    super(user.attributes)
    super(params)
  end

  def avatar=(uploaded_file)
    User::Avatar::AttachUploadedAvatar.call(user: @user, file: uploaded_file)
  end

  def save
    user.assign_attributes(email: email, first_name: first_name, last_name: last_name,
                           password: password, password_confirmation: password_confirmation)

    if valid?
      update_generated_avatar if has_generated_avatar_and_name_changed?
      persist!
    else
      false
    end
  end

  private

    def persist!
      user.save
    end

    def update_generated_avatar
      User::Avatar::AttachGeneratedAvatar.call(user: user)
    end

    def has_generated_avatar_and_name_changed?
      UserAvatar.new(user).generated_avatar? && (user.first_name_changed? || user.last_name_changed?)
    end

    def validate_user
      user.valid?
      user.errors.each do |attribute, message|
        self.errors.add(attribute, message)
      end

      user.errors.any?
    end
end
