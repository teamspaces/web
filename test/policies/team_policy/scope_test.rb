require "test_helper"

describe TeamPolicy::Scope, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_space) { spaces(:furrow) }
  let(:default_context) { DefaultPolicy::Context.new(user, team) }

  describe "#resolve" do
    it "returns user's teams" do
      policy_filtered_teams  = TeamPolicy::Scope.new(default_context, team).resolve

      assert_equal user.teams, policy_filtered_teams
    end
  end
end
