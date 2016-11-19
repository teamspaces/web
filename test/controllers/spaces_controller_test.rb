require 'test_helper'

describe SpacesController do
  before(:each) { sign_in_user }
  let(:space) { spaces(:furrow) }
  let(:team) { space.team }

  describe "#show" do
    it "works" do
      get space_url(space, subdomain: team.subdomain)
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
