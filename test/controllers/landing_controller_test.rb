require "test_helper"

describe LandingController do
  before(:each) { sign_in users(:ulf) }

  describe "#index" do
    it "works" do
      get root_url
      assert_response :success
    end
  end
end
