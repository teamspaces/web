require "test_helper"

describe PagePolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:team_space) { spaces(:furrow) }
  let(:external_space) { spaces(:power_rangers) }
  let(:team_page) { pages(:furrow) }
  let(:external_page) { pages(:power_rangers) }
  let(:page_policy_context) { PagePolicy::Context.new(user, team, team_space) }

  describe "#index?" do
    context "pages belong to a team space" do
      it "retruns true" do
        team_space_page_policy_context = PagePolicy::Context.new(user, team, team_space)

        assert PagePolicy.new(team_space_page_policy_context, team_space.pages).index?
      end
    end

    context "pages belong to another team's space" do
      it "returns false" do
        not_team_space_page_policy_context = PagePolicy::Context.new(user, team, external_space)

        refute PagePolicy.new(not_team_space_page_policy_context, team_space.pages).index?
      end
    end
  end

  context "team page" do
    it "allows show? and actions on page" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        assert PagePolicy.new(page_policy_context, team_page).send(action)
      end
    end
  end

  context "page belongs to another team" do
    it "refutes show? and actions on page" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        refute PagePolicy.new(page_policy_context, external_page).send(action)
      end
    end
  end
end