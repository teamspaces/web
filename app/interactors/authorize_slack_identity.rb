class AuthorizeSlackIdentity

  include Interactor

  def call
    @user = context.user
    @token = context.token

    login = existing_authentication.present?
    register = (login) ? false : create_authentication
    define_context_methods(login, register)

    context.user = @authentication.user
  end

    def define_context_methods(login, register)
      context.define_singleton_method(:login?) { login }
      context.define_singleton_method(:register?) { register }
    end

    def create_authentication
      user = User.create(user_attributes)
      @authentication = user.authentications.new(authentication_attributes)
      @authentication.save
    end

    def existing_authentication
      @authentication = Authentication.find_by(provider: :slack, uid: uid)
    end

    def uid
      "#{@user[:id]}-#{@user[:team_id]}"
    end

    def user_attributes
      { name: @user[:name], email: @user[:email], password: Devise.friendly_token.first(8) }
    end

    def authentication_attributes
      { provider: :slack, uid: uid, token_secret: @token }
    end
end
