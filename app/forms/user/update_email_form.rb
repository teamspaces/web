class User::UpdateEmailForm
  include FormHelpers::Errors
  include ActiveModel::Model
  include Virtus.model

  attr_reader :user
  attribute :email, String
  delegate :model_name, to: :user

  validate :validate_user

  def initialize(user, params={})
    @user = user

    super(params)
  end

  def save
    valid? && persist!
  end

  private

    def persist!
      user.regenerate_confirmation_token! if user.email_changed?
      user.postpone_email_change_until_confirmation if postpone_email_change? && email_confirmed_ever?
      user.save
      user.send_confirmation_instructions if user.email_changed?
    end

    def validate_user
      user.email = email

      add_errors_from(user)

      user.valid?
    end
end
