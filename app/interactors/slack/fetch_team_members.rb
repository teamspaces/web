class Slack::FetchTeamMembers
  include Interactor

  attr_reader :team

  def call
    @team = context.team

    context.fail! unless slack_api_token.present?
    context.fail! unless slack_team_members.present?

    context.slack_team_members = slack_team_members
  end

  def slack_team_members
    @slack_team_members ||= fetch_slack_team_members
  end

  def fetch_slack_team_members
    begin
      Slack::Web::Client.new(token: slack_api_token).users_list.members
    rescue
      context.fail!
    end
  end

  def slack_api_token
    @slack_api_token ||= begin
      team.authentications.find_by(provider: :slack_api, scopes: '{users:read}').try(:token)
    end
  end
end
