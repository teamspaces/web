require 'test_helper'

describe TeamsController do
  let(:team) { teams(:furrow) }

  describe "#spaces" do
    it "works" do
      get team_spaces_url(team_id: team.id)
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
