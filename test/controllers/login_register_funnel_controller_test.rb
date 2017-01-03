require "test_helper"

describe LoginRegisterFunnelController do

  describe "user tries to authenticate" do
    it "works" do
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end

  describe "user already signed in" do
    let(:user) { users(:lars) }
    before(:each) { sign_in user }

    it "signs out from default subdomain" do
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_nil @controller.current_user
    end

    it "redirects to sign in path for user" do
      sign_in_path = "sign_in_path"
      LoginRegisterFunnelController.any_instance.stubs(:sign_in_path_for)
                                      .returns(sign_in_path)
      get choose_login_method_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert response.redirect_url.include? sign_in_path
    end
  end
end
