require "test_helper"

describe LoginRegisterFunnel::SlackLoginRegisterController do

  describe "#login" do
    it "responds successfully" do
      get slack_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end

  describe "#register" do
    it "responds successfully" do
      get slack_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end
end
