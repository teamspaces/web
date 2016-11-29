class Slack::FetchIdentity
  include Interactor

  attr_reader :token

  def call
    @token = context.token

    context.slack_identity = fetch_slack_identity
    context.fail! unless context.slack_identity
  end

  def fetch_slack_identity
    begin
      identity = Slack::Web::Client.new(token: context.token).users_identity
      return identity if identity.ok

      Rails.logger.error "Slack::FetchIdentity#fetch_slack_identity Api returned failure response with token (token=#{context.token}), identity (#{identity.inspect})"
      return nil
    rescue => exception
      Rails.logger.error "Slack::FetchIdentity#fetch_slack_identity raised an exception (exception.class=#{exception.class} exception.message=#{exception.message}) with token (token=#{context.token})"
      return nil
    end
  end
end
