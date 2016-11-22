class Slack::FetchTeamMembers
  include Interactor

  attr_reader :team

  def call
    @team = context.team

    return context.fail! unless slack_api_token.present?

    api_call = Slack::Api.call(token: slack_api_token, ressource: "users.list")

    return context.fail! unless api_call.success?

    context.team_members = valid_members_to_invite(api_call.response[:members])
  end

  def valid_members_to_invite(members)
    slack_users = members.map { |x| Slack::User.new(x) }
    SlackUserInvitePolicy::Scope.new(team, slack_users).resolve
  end

  def slack_api_token
    @slack_api_token ||= begin
      team.authentications.find_by(provider: :slack_api, scopes: '{users:read}').try(:token)
    end
  end
end
