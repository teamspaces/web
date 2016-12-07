class Slack::TeamProfilesToInvite
  include Interactor

  attr_reader :team

  def call
    @team = context.team

    slack_team_members = fetch_slack_team_members
    context.slack_team_members = Slack::TeamProfilesToInvite::Filter.new(slack_team_members, team).filter
  end

  def fetch_slack_team_members
    begin
      Slack::Web::Client.new(token: slack_api_token).users_list.members
    rescue
      context.fail!
    end
  end

  def slack_api_token
    team.team_authentication&.token
  end
end
