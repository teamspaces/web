require "test_helper"

describe LoginRegisterFunnel::EmailLoginController do

  def fulfill_preceding_email_review_step(email)
    post review_email_address_path, params: { login_register_funnel_email_address_form: { email: email } }
  end

  def build_params(user_identification)
    { login_register_funnel_email_login_form: user_identification }
  end

  describe "#new" do
    context "completed preceding funnel steps" do
      it "works" do
        fulfill_preceding_email_review_step("email@spaces.is")
        get new_email_login_path

        assert_response :success
      end
    end

    context "skipped preceding funnel steps" do
      it "redirects to choose sign in method step" do
        get new_email_login_path

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    let(:email_user) { users(:without_team) }
    before(:each) { fulfill_preceding_email_review_step(email_user.email) }

    describe "valid" do
      before(:each) do
        post email_login_path, params: build_params({ email: email_user.email, password: "password" })
      end

      it "redirects to sign in path" do
        assert_redirected_to @controller.user_sign_in_path(email_user)
      end
    end

    context "invalid" do
      it "shows error message" do
        post email_login_path, params: build_params({ email: email_user.email, password: "wrong" })

        errors = @controller.instance_variable_get(:@email_login_form).errors.full_messages
        assert_includes errors, "Password doesn't match email address"
      end
    end
  end
end
