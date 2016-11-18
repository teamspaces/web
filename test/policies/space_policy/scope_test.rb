require "test_helper"

describe SpacePolicy::Scope, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:default_context) { DefaultContext.new(user, team) }

  describe "#resolve" do
    it "filters team spaces" do
      policy_filtered_spaces = SpacePolicy::Scope.new(default_context, Space).resolve

      assert_equal team.spaces, policy_filtered_spaces
    end
  end
end
