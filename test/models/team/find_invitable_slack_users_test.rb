require "test_helper"

describe Team::FindInvitableSlackUsers, :model do
  subject { Team::FindInvitableSlackUsers }
  let(:team) { teams(:spaces) }

  let(:invitable_slack_user) { TestHelpers::Slack.identity(:unknown_user).user }
  let(:slack_bot_user) { TestHelpers::Slack.identity(:slack_bot).user }
  let(:slack_deleted_user) { TestHelpers::Slack.identity(:deleted).user }
  let(:already_invited_slack_user) { TestHelpers::Slack.identity(:invited_user_for_spaces_team).user }
  let(:already_team_member_slack_user) { TestHelpers::Slack.identity(:existing_user).user }

  describe "#all" do
    it "returns invitable slack users" do
      slack_users = [ invitable_slack_user, slack_bot_user, slack_deleted_user,
                      already_invited_slack_user, already_team_member_slack_user]
      subject.any_instance.stubs(:all_slack_members).returns(slack_users)

      invitable_slack_users = Team::FindInvitableSlackUsers.new(team).all

      assert_equal [invitable_slack_user], invitable_slack_users
    end
  end
end
