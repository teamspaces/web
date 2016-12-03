class Slack::FetchUserInfo
  include Interactor

  attr_reader :team, :slack_id

  def call
    @team = context.team
    @slack_id = context.slack_id

    context.fail! unless slack_api_token.present?
    context.fail! unless slack_user.present?

    context.slack_user = slack_user
  end

  def slack_user
    @slack_user ||= fetch_slack_user
  end

  def fetch_slack_user
    begin
      Slack::Web::Client.new(token: slack_api_token).users_info(user: slack_id).user
    rescue
      context.fail!
    end
  end

  def slack_api_token
    @slack_api_token ||= begin
      team.authentication.try(:token)
    end
  end
end
