require "test_helper"

describe LoginRegisterFunnel::ResetPasswordsController do
  let(:user) { users(:lars) }

  def complete_preceding_email_review_step(email)
    LoginRegisterFunnel::BaseController::SharedUserInformation.any_instance
                                              .stubs(:reviewed_email_address)
                                              .returns(email)
  end


  describe "#new" do
    it "works" do
      get new_login_register_funnel_reset_password_path

      assert_response :success
    end
  end

  describe "#create" do
    context "email of existing email user" do
      it "works" do
        assert_difference 'ActionMailer::Base.deliveries.size', 1 do
          post login_register_funnel_reset_password_path, params: { login_register_funnel_password_reset_form: { email: user.email } }

          assert_redirected_to login_register_funnel_reset_password_path
        end
      end
    end
    context "invalid email" do
      it "works" do
        assert_difference 'ActionMailer::Base.deliveries.size', 0 do
          post login_register_funnel_reset_password_path, params: { login_register_funnel_password_reset_form: { email: "despcaito" } }

          assert_response :success
        end
      end
    end
  end

  describe "#show" do
    it "works" do
      complete_preceding_email_review_step(user.email)
      get login_register_funnel_reset_password_path

      assert_response :success
    end
  end
end
