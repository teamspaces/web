require "test_helper"

describe SpacePolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_space) { spaces(:furrow) }
  let(:external_space) { spaces(:power_rangers) }
  let(:default_context) { DefaultContext.new(user, team) }

  context "team space" do
    it "permits show and actions on space" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        assert SpacePolicy.new(default_context, team_space).send(action)
      end
    end
  end

  context "space does not belong to team" do
    it "prevents show and actions on space" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        refute SpacePolicy.new(default_context, external_space).send(action)
      end
    end
  end
end
