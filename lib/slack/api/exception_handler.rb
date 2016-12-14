class Slack::Api::ExceptionHandler

  attr_reader :exception, :authentication

  def initialize(exception, authentication)
    @exception = exception
    @authentication = authentication

    clear_exception_perpetrator
  end

  private
    def clear_exception_perpetrator
      authentication&.destroy if invalid_token_provided?
    end

    def invalid_token_provided?
      exception.is_a?(Slack::Web::Api::Error) &&
      [ "invalid_auth", "account_inactive", "not_authed" ].include?(exception.message)
    end
end
