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

      Rails.logger.error "slack api returned failure response #{identity.inspect}"
      return nil
    rescue
      Rails.logger.error "failed to fetch slack identity"
      return nil
    end
  end
end
