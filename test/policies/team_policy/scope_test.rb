require "test_helper"

describe TeamPolicy::Scope, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:default_context) { DefaultContext.new(user, team) }

  describe "#resolve" do
    it "returns user's teams" do
      policy_filtered_teams  = TeamPolicy::Scope.new(default_context, Team).resolve

      assert_equal user.teams, policy_filtered_teams
    end
  end
end
