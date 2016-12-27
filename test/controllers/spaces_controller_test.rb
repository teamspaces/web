require 'test_helper'

describe SpacesController do
  before(:each) { sign_in users(:ulf) }
  let(:space) { spaces(:spaces) }

  describe "#show" do
    it "works" do
      get space_url(space, subdomain: space.team.subdomain)
      assert_response :success
    end
  end

  # TODO: Test all methods
  describe "all other methods" do
    it "need testing" do
      # skip
    end
  end
end
