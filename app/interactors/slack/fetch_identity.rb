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

      Rails.logger.error "Slack::FetchIdentity#fetch_slack_identity failed token=#{context.token}, identity=#{identity.inspect}"
      return nil
    rescue => exception
      Rails.logger.error "Slack::FetchIdentity#fetch_slack_identity token=#{context.token} raised #{exception.class}: #{exception.message}"
      return nil
    end
  end
end
