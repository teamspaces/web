require "test_helper"

describe LoginRegisterFunnel::EmailRegisterController do

  def fulfill_preceding_email_review_step(email)
    post review_email_address_path, params: { login_register_funnel_email_address_form: { email: email } }
  end

  def build_params(user_identification)
    { login_register_funnel_email_register_form: user_identification }
  end

  describe "#new" do
    context "completed preceding funnel steps" do
      it "works" do
        fulfill_preceding_email_review_step("email@spaces.is")
        get new_email_register_path

        assert_response :success
      end
    end

    context "skipped preceding funnel steps" do
      it "redirects to choose sign in method step" do
        get new_email_register_path

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    let(:email) { "icon@spaces.is" }
    before(:each) { fulfill_preceding_email_review_step(email) }

    describe "valid" do

      def post_user_data
        post email_register_path, params: build_params({email: email,
                                                        password: "password",
                                                        password_confirmation: "password",
                                                        first_name: "Julia",
                                                        last_name: "Simmons"})
      end

      it "creates user" do
        assert_difference -> { User.count }, 1 do
          post_user_data
        end
      end

      it "redirects to sign in path" do
        post_user_data

        assert_redirected_to @controller.user_sign_in_path(User.last)
      end
    end

    describe "invalid" do
      it "shows errors" do
        post email_register_path, params: build_params({email: "scooter@spaces.is",
                                                        password: "password",
                                                        password_confirmation: "pp"})

        errors = @controller.instance_variable_get(:@email_register_form).errors.full_messages
        assert_includes errors, "Password confirmation doesn't match Password"
        assert_includes errors, "First name can't be blank"
      end
    end
  end
end
