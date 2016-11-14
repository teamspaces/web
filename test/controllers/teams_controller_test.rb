require 'test_helper'

describe TeamsController do
  before(:each) { sign_in_user }
  let(:team) { teams(:furrow) }

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
