class Slack::FetchTeamProfiles
  include Interactor

  attr_reader :team

  def call
    @team = context.team
    @memory_first = context.memory_first

    destroy_existing_team_profiles
    fetch_and_store_slack_team_profiles

    context.slack_team_profiles = slack_team_profiles
  end

  def slack_team_profiles
    team.team_authentication.slack_profiles
  end

  def destroy_existing_team_profiles
    team.team_authentication.slack_profiles.destroy_all
  end

  def fetch_and_store_slack_team_profiles
    fetch_slack_team_members.each do |slack_team_member|
      Slack::SaveSlackProfile.call(slack_user: slack_team_member)
    end
  end

  def fetch_slack_team_members
    begin
      Slack::Web::Client.new(token: slack_api_token).users_list.members
    rescue
      context.fail!
    end
  end

  def slack_api_token
    team.team_authentication.try(:token)
  end
end
