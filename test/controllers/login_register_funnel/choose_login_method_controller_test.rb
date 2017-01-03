require "test_helper"

describe LoginRegisterFunnel::ChooseLoginMethodController do

  describe "#index" do
    it "responds successfully" do
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end
end
