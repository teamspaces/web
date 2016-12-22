require "test_helper"

describe LoginRegisterFunnel::ReviewEmailAddressController do

  def build_params(email)
    { login_register_funnel_email_address_form: { email: email} }
  end

  describe "#new" do
    before(:each) { get new_review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]) }

    it { assert_response :success }
  end

  describe "#review" do
    context "valid email address" do
      describe "new user" do
        let(:unkown_email_address) { "new_email@spaces.is" }

        it "redirects to email register" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(unkown_email_address)

          assert_redirected_to new_email_register_path
        end
      end

      describe "existing email user" do
        let(:existing_email_user) { users(:ulf) }

        it "redirects to email login" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(existing_email_user.email)

          assert_redirected_to new_email_login_path
        end
      end

      describe "existing slack user email" do
         let(:slack_user) { users(:slack_user_milad) }

        it "redirects to register with email" do
          post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(slack_user.email)

          assert_redirected_to new_email_register_path
        end
      end
    end

    context "invalid email address" do
      it "shows form error message" do
        post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params("invalid")

        errors = @controller.instance_variable_get(:@email_address_form).errors.full_messages
        assert_includes errors, "Email is invalid"
      end
    end
  end
end
