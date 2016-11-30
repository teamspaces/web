class SlackTeamAuthenticationPolicy

  attr_reader :team, :user, :slack_authentication_info

  def initialize(team, user, slack_authentication_info)
    @team = team
    @user = user
    @slack_authentication_info = slack_authentication_info
  end

  def matching?
    if existing_user_authentications_to_slack.any?
      return user_authentications_match_slack_team_authentication?
    elsif existing_team_authentications_to_slack.any?

    else

    end
  end

  def user_authentications_match_slack_team_authentication?
    slack_authentication = existing_user_authentications_to_slack.first
    team.id == Slack::Identity::UID.parse(slack_authentication.uid)[:team_id]
  end

  private

    def existing_team_authentications_to_slack
      @existing_team_authentications_to_slack ||= team.authentications # where slack
    end

    def existing_user_authentications_to_slack
      @existing_user_authentications_to_slack ||= team.users.authentications #where slack provider
    end
end
