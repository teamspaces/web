require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }

  before(:each) { sign_in user }

  describe "#create" do
    it "creates team" do
      assert_difference -> { Team.count }, 1 do
        post teams_path, params: { team_for_user_form: { name: "new_team" } }
      end
    end

    it "team has creator as primary owner" do
      post teams_path, params: { team_for_user_form: { name: "emm" } }

      assert_equal Team.last.primary_owner.user, user
    end
  end

  describe "#spaces" do
    it "works" do
      get team_spaces_url(team)
      assert_response :success
    end
  end

  # TODO: Test all methods
  describe "all other methods" do
    it "need testing" do
      skip
    end
  end
end
