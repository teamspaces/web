require "test_helper"

describe LoginRegisterFunnel::EmailRegisterController do

  def complete_preceding_email_review_step(email)
    post review_email_address_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: { login_register_funnel_email_address_form: { email: email } }
  end

  def build_params(user_attributes)
    { login_register_funnel_email_register_form: user_attributes }
  end

  describe "#new" do
    context "user completed review email address step" do
      it "responds successfully" do
        complete_preceding_email_review_step("email@spaces.is")
        get new_email_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user did not complete review email address step" do
      it "redirects to choose sign in method step" do
        get new_email_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    let(:email) { "icon@spaces.is" }
    before(:each) { complete_preceding_email_review_step(email) }

    describe "valid user attributes" do
      def post_valid_user_attributes
        valid_user_attributes = { email: email, first_name: "Julia", last_name: "Simmons",
                                  password: "password", password_confirmation: "password" }

        post email_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(valid_user_attributes)
      end

      it "creates user" do
        assert_difference -> { User.count }, 1 do
          post_valid_user_attributes
        end
      end

      it "redirects user to sign in path" do
        post_valid_user_attributes

        assert_redirected_to @controller.sign_in_path_for(User.last)
      end
    end

    describe "invalid user attributes" do
      def post_invalid_user_attributes
        invalid_user_attributes = { email: "scooter@spaces.is", password: "password", password_confirmation: "pp" }

        post email_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params(invalid_user_attributes)
      end

      it "shows error message" do
        post_invalid_user_attributes

        errors = @controller.instance_variable_get(:@email_register_form).errors.full_messages
        assert_includes errors, "Password confirmation doesn't match Password"
        assert_response :success
      end
    end
  end
end
