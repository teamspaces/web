require 'test_helper'

describe TeamsController do
  include Devise::Test::IntegrationHelpers

  let(:team) { teams(:furrow) }

  describe "#spaces" do
    it "works" do
      sign_in users(:lars)

      get team_spaces_url(team)
      assert_response :success
    end
  end
end
