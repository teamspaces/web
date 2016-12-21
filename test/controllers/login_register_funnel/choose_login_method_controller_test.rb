require "test_helper"

describe LoginRegisterFunnel::ChooseLoginMethodController do

  describe "#index" do
    before(:each) { get choose_login_method_path }

    it { assert_response :success }
  end
end
