require "test_helper"

describe LoginRegisterFunnel::BaseController do

  describe "user tries to authenticate" do
    it "works" do
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end

  describe "user already signed in" do
    let(:user) { users(:lars) }
    before(:each) do
      sign_in user
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end

    it "signs out from default subdomain" do
      assert_nil @controller.send(:current_user)
    end

    it "redirects to sign in url for user" do
      assert_redirected_to @controller.sign_in_url_for(user: user)
    end
  end
end
