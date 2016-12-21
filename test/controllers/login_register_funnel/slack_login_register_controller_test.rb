require "test_helper"

describe LoginRegisterFunnel::SlackLoginRegisterController do

  describe "#login" do
    before(:each) { get slack_login_path }

    it { assert_response :success }
  end

  describe "#register" do
    before(:each) { get slack_register_path }

    it { assert_response :success }
  end
end
