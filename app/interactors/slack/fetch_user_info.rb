class Slack::FetchUserInfo
  include Interactor

  attr_reader :team, :user_id

  def call
    @team = context.team
    @user_id = context.user_id

    context.slack_user = fetch_slack_user
  end

  def fetch_slack_user
    begin
      Slack::Web::Client.new(token: slack_api_token).users_info(user: user_id).user
    rescue
      context.fail!
    end
  end

  def slack_api_token
    team.team_authentication&.token
  end
end
