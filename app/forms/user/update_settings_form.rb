class User::UpdateSettingsForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :user

  attribute :email, String
  attribute :first_name, String
  attribute :last_name, String
  attribute :password, String
  attribute :avatar
  attribute :password_confirmation, String

  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :validate_user

  def initialize(user, params={})
    @user = user
    @user.avatar_attacher.context[:source] = User::Avatar::Source::UPLOADED if params[:avatar]
    params.each { |name,value| user.send("#{name}=", value) }
    self.attributes.each { |name, value| send("#{name}=", user.send(name)) }
  end

  def cached_avatar_data
    user.cached_avatar_data
  end

  def avatar_url(opt)
    user.avatar_url(opt)
  end

  def save
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
      user.generated_avatar? && (user.first_name_changed? || user.last_name_changed?)
    end

    def validate_user
      user.valid?
      user.errors.each do |attribute, message|
        self.errors.add(attribute, message)
      end
      user.valid?
    end
end
