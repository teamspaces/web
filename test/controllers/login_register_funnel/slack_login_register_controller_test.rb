require "test_helper"

describe LoginRegisterFunnel::SlackLoginRegisterController do

  describe "#login" do
    it "works" do
      get slack_login_path

      assert_response :success
    end
  end

  describe "#register" do
    it "works" do
      get slack_register_path

      assert_response :success
    end
  end
end
