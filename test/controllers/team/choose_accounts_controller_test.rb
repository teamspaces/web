require 'test_helper'

describe Team::ChooseAccountsController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }

  describe "#new" do
    it "works" do
      get new_team_choose_account_url(subdomain: team.subdomain)
      assert_response :success
    end
  end
end
