require "test_helper"

describe TeamMemberPolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:team_member) { team_members(:lars_at_spaces) }
  let(:default_context) { DefaultContext.new(user, team) }

  describe "#destroy?" do
    it "works" do
      assert TeamMemberPolicy.new(default_context, team_member).destroy?
    end

    context "team member does not belong to team" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, team_member).destroy?
      end
    end

    context "user removes himself from team" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, team_member).destroy?
      end
    end

    context "team member to delete is primary owner" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, team_member).destroy?
      end
    end
  end
end
