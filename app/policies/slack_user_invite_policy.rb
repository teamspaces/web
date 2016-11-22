class SlackUserInvitePolicy
  class Scope

    def initialize(team, scope)
      @team  = team
      @scope = scope

      @team_emails = team.users.map(&:email)
    end

    def resolve
      existent.human.not_team_member
      @scope
    end

      def existent
        @scope = @scope.reject { |user| user.deleted }
        self
      end

      def human
        @scope = @scope.reject { |user| user.is_bot || user.name == "slackbot"}
        self
      end

      def not_team_member
        @scope = @scope.reject { |user| @team_emails.include? user.email }
        self
      end
  end
end
