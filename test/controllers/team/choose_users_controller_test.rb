require 'test_helper'

describe Team::ChooseUsersController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }
  before(:each){ sign_in user }

  describe "#new" do
    it "works" do
      get new_team_choose_user_url(subdomain: team.subdomain)
      assert_response :success
    end
  end
end
