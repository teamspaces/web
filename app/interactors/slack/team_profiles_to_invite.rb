class Slack::TeamProfilesToInvite
  include Interactor

  attr_reader :team

  def call
    @team = context.team

    @slack_team_members = fetch_slack_team_members

    user_ids = team.authentications.map do |authentication|
      Slack::Identity::UID.parse(authentication.uid)[:user_id]
    end

    invite_ids = team.invitations.map(&:slack_user_id)

    @slack_team_members.reject! { |i| i.name == "slackbot" }
    @slack_team_members.reject! { |i| i.deleted == true }
    @slack_team_members.reject! { |i| invite_ids.include? i.user_id }
    @slack_team_members.reject! { |i| user_ids.include? i.user_id }

    context.slack_team_members = @slack_team_members
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
