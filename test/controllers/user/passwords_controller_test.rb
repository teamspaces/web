require "test_helper"

describe Devise::PasswordsController do
  before(:each) { GenerateLoginToken.stubs(:call).returns("user_login_token") }

  describe "#edit" do
    it "works" do
      get edit_user_password_path(reset_password_token: "hello", subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end

  describe "#update" do
    let(:user) { users(:ulf) }
    let(:password_reset_token) { user.send_reset_password_instructions }

    context "valid password provided" do
      it "works, redirects to sign in path for user" do
        patch user_password_path(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: { user: { password: "cheddar",
                                                                                         password_confirmation: "cheddar",
                                                                                         reset_password_token: password_reset_token } }
        assert_redirected_to @controller.sign_in_url_for(user: user)
      end
    end

    context "invalid password provided" do
      it "works" do
        patch user_password_path(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: { user: { password: "wrong",
                                                                                         password_confirmation: "cheddar",
                                                                                         reset_password_token: password_reset_token } }
        assert_response :success
      end
    end
  end
end
