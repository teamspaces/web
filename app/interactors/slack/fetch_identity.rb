class Slack::FetchIdentity
  include Interactor

  attr_reader :token

  def call
    @token = context.token

    context.slack_identity = fetch_slack_identity
  end

  def fetch_slack_identity
    begin
      identity = Slack::Web::Client.new(token: context.token).users_identity
      context.fail! unless identity.ok

      identity
    rescue
      Rails.logger.error "failed to fetch user from slack"
      context.fail!
      nil
    end
  end
end
