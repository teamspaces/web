require "test_helper"

describe LandingController do
  describe "#index" do
    it "works" do
      get root_url
      assert_response :success
    end
  end
end
