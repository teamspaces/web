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


  def initialize(user, attri={})
    @user = user
    attri.each { |name,value| user.send("#{name}=", value) }
    self.attributes.each { |name, value| send("#{name}=", user.send(name)) }
    if attri[:avatar]
      attacher = Shrine::AvatarUploader::Attacher.new(@user, :avatar)
      attacher.context[:source] = User::Avatar::Source::UPLOADED
      attacher.assign(avatar)
    end

    debugger
  end

  def update_generated_avatar
    User::AttachGeneratedAvatar.call(user: self)
  end

  def generated_avatar_and_name_changed?
    generated_avatar? && (first_name_changed? || last_name_changed?)
  end

  def cached_avatar_data
    user.cached_avatar_data
  end

  def avatar_url(opt)
    user.avatar_url(opt)
  end

  def validate_user
    user.valid?
    user.errors.each do |attribute, message|
      self.errors.add(attribute, message)
    end
    user.valid?
  end

  def save
    valid? && persist!
  end

  def persist!
    user.save
  end
end
