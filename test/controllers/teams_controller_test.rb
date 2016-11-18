require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }

  before(:each) { sign_in user }


  describe "#show" do
    context "user is team member" do
      it "shows team page" do
        get team_url(subdomain: team.name)
        assert_response :success
      end
    end
  end

  describe "#create" do
    it "creates team" do
      skip
      assert_difference -> { Team.count }, 1 do
        post teams_path, params: { create_team_for_user_form: { name: "new_team" } }
      end
    end

    it "team has creator as primary owner" do
      skip
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
