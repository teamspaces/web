require "test_helper"

describe PagePolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:space) {}
  let(:page_policy_context) { PagePolicy::Context.new(user, team) }

  context "team invitation" do
    it "permits invitation deletion" do
      assert InvitationPolicy.new(default_context, team_invitation).destroy?
    end
  end

  context "invation belongs not to user team" do
    it "prevents invitation deletion" do
      refute InvitationPolicy.new(default_context, external_invitation).destroy?
    end
  end
end
