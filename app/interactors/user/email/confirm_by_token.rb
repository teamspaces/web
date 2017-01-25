class User::Email::ConfirmByToken
  include Interactor

  def call
    @user = context.user
    @confirmation_token = confirmation_token

    #fail if nil

    confirm_by_token
  end

   def confirm_by_token
    user = User.find_by(confirmation_token: @confirmation_token)
    user.errors.add(:confirmation_token, :blank) if user.confirmed?

      confirmable = find_first_by_auth_conditions()
      unless confirmable
        confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
        confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_digest)
      end

        # TODO: replace above lines with
        # confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
        # after enough time has passed that Devise clients do not use digested tokens

        confirmable.confirm if confirmable.persisted?
        confirmable
      end
end
