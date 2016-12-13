class Team::FindInvitableSlackUsers
  def initialize(team)
    @team = team
  end

  def all
    all_slack_members.reject(&match_bot?)
                     .reject(&match_deleted?)
                     .reject(&match_already_invited?)
                     .reject(&match_already_team_member?)
  end

  private

    def all_slack_members
      token = @team.team_authentication&.token

      begin
        Slack::Web::Client.new(token: token).users_list.members
      rescue
        Rails.logger.error("Team::FindInvitableSlackUsers#all_slack_members failed to fetch slack team members (team.id=#{@team.id})")

        []
      end
    end

    def match_bot?
      lambda do |x|
        x.is_bot == true || x.name == "slackbot" || x.id == "USLACKBOT"
      end
    end

    def match_deleted?
      lambda { |x| x.deleted == true }
    end

    def match_already_invited?
      invited_user_ids = @team.invitations.map(&:slack_user_id)

      lambda { |x| invited_user_ids.include? x.id }
    end

    def match_already_team_member?
      team_member_ids = @team.user_authentications.map do |authentication|
        Slack::Identity::UID.parse(authentication.uid)[:user_id]
      end

      lambda { |x| team_member_ids.include? x.id }
    end
end
