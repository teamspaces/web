class SlackProfile::ToInvitePolicy::Scope
  attr_reader :team, :scope

  def initialize(team, scope)
    @team = team
    @scope = scope
  end

  def resolve
    @scope = not_roboter?
    @scope = not_deleted?
    @scope = not_team_member?
  end

  private

    def not_roboter?
      scope.where.not(name: "slackbot")
    end

    def not_deleted?
      scope.where.not(deleted: true)
    end

    def not_team_member?
      user_ids = team.authentications.map do |authentication|
        Slack::Identity::UID.parse(authentication.uid)[:user_id]
      end

      scope.where.not(user_id: user_ids)
    end
end
