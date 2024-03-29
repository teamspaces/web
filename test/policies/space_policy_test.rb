require "test_helper"

describe SpacePolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:team_space) { spaces(:spaces) }
  let(:external_space) { spaces(:power_rangers) }
  let(:default_context) { DefaultContext.new(user, team) }

  context "team space" do
    it "allows show? and actions on space" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        assert SpacePolicy.new(default_context, team_space).send(action)
      end
    end
  end

  context "space belongs to another team" do
    it "refutes show? and actions on space" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        refute SpacePolicy.new(default_context, external_space).send(action)
      end
    end
  end
end
