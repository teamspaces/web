class User::SendConfirmationInstructions
  include Interactor

  def call
    @user = context.user

    send_confirmation_instructions
  end

  def send_confirmation_instructions
    save_confirmation_token_and_sent_time unless already_sent?

    @user.send_confirmation_instructions
  end

  def already_sent?
    @user.confirmation_sent_at.present?
  end

  def save_confirmation_token_and_sent_time
    @user.confirmation_token = Devise.friendly_token
    @user.confirmation_sent_at = Time.now.utc
    @user.save(validate: false)
  end
end
