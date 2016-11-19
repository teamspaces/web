require "test_helper"

describe InvitationPolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_invitation) { invitations(:jonas_at_furrow) }
  let(:external_invitation) { invitations(:sven_at_power_rangers) }
  let(:default_context) { DefaultContext.new(user, team) }

  describe "#destroy?" do
    context "team invitation" do
      it "returns true" do
        assert InvitationPolicy.new(default_context, team_invitation).destroy?
      end
    end

    context "invitation belongs to another team" do
      it "returns false" do
        refute InvitationPolicy.new(default_context, external_invitation).destroy?
      end
    end
  end
end
