require "test_helper"

describe SpacePolicy::Scope, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:team_space) { spaces(:spaces) }
  let(:external_team_space) { spaces(:power_rangers) }
  let(:user_private_space) { spaces(:private) }
  let(:external_private_space) { spaces(:private_slack_user_milad) }
  let(:default_context) { DefaultContext.new(user, team) }

  describe "#resolve" do
    it "filters team spaces and private spaces user has access to" do
      policy_filtered_spaces = SpacePolicy::Scope.new(default_context, Space).resolve

      [team_space, user_private_space].each do |space|
        assert_includes policy_filtered_spaces, space
      end

      [external_team_space, external_private_space].each do |space|
        assert_not_includes policy_filtered_spaces, space
      end
    end
  end
end
