require "test_helper"

describe LoginRegisterFunnel::ChooseLoginMethodController do

  describe "#index" do
    before(:each) { get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]) }

    it { assert_response :success }
  end
end
