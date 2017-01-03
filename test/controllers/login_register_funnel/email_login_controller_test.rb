require "test_helper"

describe LoginRegisterFunnel::EmailLoginController do

  def complete_preceding_email_review_step(email)
    post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: { login_register_funnel_email_address_form: { email: email } }
  end

  def build_params(user_identification)
    { login_register_funnel_email_login_form: user_identification }
  end

  describe "#new" do
    context "user completed review email address step" do
      it "responds successfully" do
        complete_preceding_email_review_step("email@spaces.is")
        get new_email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user did not complete review email address step" do
      it "redirects to choose sign in method step" do
        get new_email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    let(:email_user) { users(:without_team) }
    before(:each) { complete_preceding_email_review_step(email_user.email) }

    context "valid username, password" do
      it "finds user and redirects to sign in path" do
        post email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params({ email: email_user.email, password: "password" })

        assert_redirected_to @controller.sign_in_path_for(email_user)
      end
    end

    context "invalid username, password" do
      it "responds" do
        post email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params({ email: email_user.email, password: "wrong" })

        assert_response :success
      end
    end
  end
end
