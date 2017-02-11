require "test_helper"

describe PageContentPolicy, :model do
  let(:user) { users(:ulf) }
  let(:team) { teams(:spaces) }
  let(:page_content) { page_contents(:default) }
  let(:policy_context) { PagePolicy::Context.new(user, team) }
  subject { PageContentPolicy.new(policy_context, page_content) }

  describe "#show?" do
    it "responds" do
      assert_respond_to subject, :show?
    end
  end

  describe "#update?" do
    it "responds" do
      assert_respond_to subject, :update?
    end
  end
end
