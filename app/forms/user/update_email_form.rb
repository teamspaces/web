class User::UpdateEmailForm
  include FormHelpers::Errors
  include ActiveModel::Model
  include Virtus.model

  attr_reader :user
  attribute :email, String
  delegate :model_name, to: :user

  validate :validate_user

  def initialize(user:, attributes: {})
    @user = user

    super(attributes)
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      user.save
    end

    def validate_user
      user.email = email

      add_errors_from(user)

      user.valid?
    end
end
