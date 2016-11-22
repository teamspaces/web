require "test_helper"

describe PagePolicy::Scope, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_space) { spaces(:furrow) }
  let(:page_policy_context) { PagePolicy::Context.new(user, team, team_space) }

  describe "#resolve" do
    it "filters team space pages" do
      policy_filtered_spaces  = PagePolicy::Scope.new(page_policy_context, Page).resolve

      assert_equal team_space.pages, policy_filtered_spaces
    end
  end
end
