class Team::FindSlackUsers
  def initialize(team)
    @team = team
  end

  def without_invitation
    all - with_open_invitation - with_accepted_invitation
  end

  def with_open_invitation
    all.select(&match_with_open_invitation?)
  end

  def with_accepted_invitation
    all.select(&match_with_accepted_invitation?)
  end

  def all
    @all ||= all_slack_members.reject(&match_bot?)
                              .reject(&match_deleted?)
                              .reject(&match_already_team_member?)
  end

  private

    def all_slack_members
      team_authentication = @team.team_authentication

      begin
        CustomSlackClient.new(token: team_authentication.token).users_list.members
      rescue Slack::Web::Api::Error => exception
        if exception.message == "token_revoked"
          team_authentication.destroy
        else
          Rails.logger.error("Team::FindInvitableSlackUsers#all_slack_members failed (team.id=#{@team.id}) with (#{exception.class}=#{exception.message})")
          Raven.capture_exception(exception, extra: { team_id: @team.id })
        end

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

    def match_with_open_invitation?
      invited_user_uids = @team.invitations.unused.map(&:invited_slack_user_uid)

      lambda { |x| invited_user_uids.include? x.id }
    end

    def match_with_accepted_invitation?
      invited_user_uids = @team.invitations.used.map(&:invited_slack_user_uid)

      lambda { |x| invited_user_uids.include? x.id }
    end

    def match_already_team_member?
      team_member_ids = @team.user_authentications.map do |authentication|
        Slack::Identity::UID.parse(authentication.uid)[:user_id]
      end

      lambda { |x| team_member_ids.include? x.id }
    end
end
