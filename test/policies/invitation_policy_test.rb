require "test_helper"

describe InvitationPolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_invitation) { invitations(:jonas_at_furrow) }
  let(:external_invitation) { invitations(:sven_at_power_rangers) }
  let(:default_context) { DefaultContext.new(user, team) }

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
