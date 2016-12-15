require "test_helper"

describe LoginRegisterFunnel::ChooseLoginMethodController do

  describe "#index" do
    it "works" do
      get choose_login_method_path

      assert_response :success
    end
  end
end
