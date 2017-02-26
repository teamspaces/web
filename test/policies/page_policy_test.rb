require "test_helper"

describe PagePolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:team_space) { spaces(:spaces) }
  let(:external_space) { spaces(:power_rangers) }
  let(:team_page) { pages(:spaces) }
  let(:nested_page) { pages(:max_nested_page) }
  let(:external_page) { pages(:power_rangers) }
  let(:private_without_access) { pages(:private_slack_user_milad) }
  let(:page_policy_context) { PagePolicy::Context.new(user, team, team_space) }

  describe "#create?" do
    it "is true" do
      assert PagePolicy.new(page_policy_context, team_page).create?
    end

    context "reached nested page limit" do
      it "is false" do
        page = pages(:with_parent)
        page.stubs(:depth).returns(ENV["NESTED_PAGE_LIMIT"])

        refute PagePolicy.new(page_policy_context, page).create?
      end
    end
  end

  describe "allowed_to_access?" do
    context "team page and user allowed to access space" do
      it "allows show? and actions on page" do
        [:show?, :new?, :edit?, :update?, :destroy?].each do |action|
          assert PagePolicy.new(page_policy_context, team_page).send(action)
        end
      end
    end

    context "page belongs to another team" do
      it "refutes show? and actions on page" do
        [:show?, :new?, :edit?, :update?, :destroy?].each do |action|
          refute PagePolicy.new(page_policy_context, external_page).send(action)
        end
      end
    end

    context "space is private, user has no access" do
      it "refutes show? and actions on page" do
        [:show?, :new?, :edit?, :update?, :destroy?].each do |action|
          refute PagePolicy.new(page_policy_context, private_without_access).send(action)
        end
      end
    end
  end
end
