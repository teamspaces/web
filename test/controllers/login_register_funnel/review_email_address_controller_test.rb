require "test_helper"

describe LoginRegisterFunnel::ReviewEmailAddressController do

  def build_params(email)
    { login_register_funnel_email_address_form: { email: email} }
  end

  describe "#new" do
    it "responds successfully" do
      get new_review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end

  describe "#review" do
    context "valid email address" do
      describe "new user" do
        let(:unkown_email_address) { "new_email@spaces.is" }

        it "redirects to email register path" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(unkown_email_address)

          assert_redirected_to new_email_register_path
        end
      end

      describe "existing email user" do
        let(:existing_email_user) { users(:ulf) }

        it "redirects to email login path" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(existing_email_user.email)

          assert_redirected_to new_email_login_path
        end
      end

      describe "existing slack user email" do
         let(:slack_user) { users(:slack_user_milad) }

        it "redirects to register with email path" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(slack_user.email)

          assert_redirected_to new_email_register_path
        end
      end
    end

    context "invalid email address" do
      it "does not redirect" do
        post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params("invalid")

        assert_response :success
      end
    end
  end
end
