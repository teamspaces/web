class SlackTeamAuthenticationPolicy

  attr_reader :team, :user, :slack_authentication_info

  def initialize(team, user, slack_authentication_info)
    @team = team
    @user = user
    @slack_authentication_info = slack_authentication_info
  end

  def matching?
    if existing_user_authentications_to_slack.any?
      user_authentications_match_slack_team_authentication?
    elsif existing_team_authentications_to_slack.any?
      team_authentications_match_slack_team_authentication?
    elsif user_is_primary_owner?
      true
    else
      false
    end
  end

  def user_authentications_match_slack_team_authentication?
    user_authentication = existing_user_authentications_to_slack.first
    slack_authentication_info.team_id == Slack::Identity::UID.parse(user_authentication.uid)[:team_id]
  end

  def team_authentications_match_slack_team_authentication?
    team_authentication = existing_team_authentications_to_slack.first
    slack_authentication_info.team_id == team_authentication.foreign_team_id
  end

  private

    def existing_team_authentications_to_slack
      @existing_team_authentications_to_slack ||= team.team_authentications.where(provider: :slack)
    end

    def existing_user_authentications_to_slack
      @existing_user_authentications_to_slack ||= team.user_authentications.where(provider: :slack)
    end

    def user_is_primary_owner?
      user.team_members.find_by(team_id: team.id).primary_owner?
    end
end
