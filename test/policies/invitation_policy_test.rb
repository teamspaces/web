require "test_helper"

describe InvitationPolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:team_invitation) { invitations(:jonas_at_spaces) }
  let(:external_invitation) { invitations(:katharina_at_power_rangers) }
  let(:used_invitation) { invitations(:used_invitation) }
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

    context "invitation already used" do
      it "returns false" do
        refute InvitationPolicy.new(default_context, used_invitation).destroy?
      end
    end
  end

  describe "#send?" do
    context "team invitation" do
      it "returns true" do
        assert InvitationPolicy.new(default_context, team_invitation).send?
      end
    end

    context "invitation belongs to another team" do
      it "returns false" do
        refute InvitationPolicy.new(default_context, external_invitation).send?
      end
    end
  end
end
