class User::SlackLoginForm
  include Inflorm

  attr_reader :authentication

  attribute :uid, String
  validates :uid, presence: true

  def login
    !!find_authentication
  end

  def user
    authentication&.user
  end

  private

    def find_authentication
      @authentication = Authentication.find_by(provider: :slack,
                                               uid: uid)
    end
end
