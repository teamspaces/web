class User::Email::Confirm
  include Interactor

  def call
    @user = context.user

    confirm_email
  end

  def confirm_email
    @user.confirmed_at = Time.now.utc

    if @user.unconfirmed_email.present?
      @user.email = @user.unconfirmed_email
      @user.unconfirmed_email = nil
    end

    @user.save(validate: true)
  end
end
