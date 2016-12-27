require "test_helper"

describe LandingController do
  before(:each) { sign_in users(:ulf) }

  describe "#index" do
    it "works" do
      get landing_url
      assert_response :success
    end
  end
end
