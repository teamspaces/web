class SlackTeamAuthenticationPolicy

  attr_reader :team, :slack_authentication_info

  def initialize(team, slack_authentication_info)
    @team = team
    @slack_authentication_info = slack_authentication_info
  end

  def matching?
    if existing_user_authentications_to_slack.any?
      user_authentications_match_slack_team_authentication?
    else
      true
    end
  end

  def user_authentications_match_slack_team_authentication?
    user_authentication = existing_user_authentications_to_slack.first
    slack_authentication_info.team_id == Slack::Identity::UID.parse(user_authentication.uid)[:team_id]
  end

  private

    def existing_user_authentications_to_slack
      @existing_user_authentications_to_slack ||= team.user_authentications.where(provider: :slack)
    end
end
