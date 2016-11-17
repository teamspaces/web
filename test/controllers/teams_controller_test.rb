require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:no_membership_team) { teams(:power_rangers) }

  before(:each) { sign_in user }


  describe "#show" do
    context "user is team member" do
      it "shows team page" do
        get team_url(subdomain: team.name)
        assert_response :success
      end
    end

    context "user not team member" do
      it "redirects to landing" do
        get team_url(subdomain: no_membership_team.name)
      end
    end
  end

  describe "#create" do
    it "creates team" do
      assert_difference -> { Team.count }, 1 do
        post teams_path, params: { create_team_for_user_form: { name: "new_team" } }
      end
    end

    it "team has creator as primary owner" do
      post teams_path, params: { create_team_for_user_form: { name: "emm" } }

      assert_equal Team.last.primary_owner.user, user
    end
  end

  # TODO: Test all methods
  describe "all other methods" do
    it "need testing" do
      skip
    end
  end
end
