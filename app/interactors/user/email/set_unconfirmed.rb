class User::Email::SetUnconfirmed
  include Interactor

  def call
    @user = context.user
    @email = context.email

    set_email unless email_stays_the_same?
  end

  def email_stays_the_same?
    (@user.email && @user.unconfirmed_email.nil? && @user.email == email) ||
    (@user.unconfirmed_email == email)
  end

  def email_not_yet_confirmed?
    !@user.confirmed? && @user.unconfirmed_email.nil?
  end

  def set_email
    @user.confirmation_sent_at = nil
    @user.confirmation_token = Devise.friendly_token
    @user.confirmed_at = nil

    if email_not_yet_confirmed?
      @user.email = @email
    else
      @user.unconfirmed_email =  @email
    end
  end
end
