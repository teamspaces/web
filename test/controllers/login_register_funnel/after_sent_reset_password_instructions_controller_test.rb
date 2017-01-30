require "test_helper"

describe LoginRegisterFunnel::AfterSentResetPasswordInstructionsController do
  let(:user) { users(:lars) }

  def complete_preceding_email_review_step(email)
    LoginRegisterFunnel::BaseController::SharedUserInformation.any_instance
                                              .stubs(:reviewed_email_address)
                                              .returns(email)
  end


  describe "#new" do
    context "user did complete review email address step" do
      it "works" do
        complete_preceding_email_review_step(user.email)
        get new_login_register_funnel_after_sent_reset_password_instruction_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user did not complete review email address step" do
      it "redirects to choose sign in method step" do
        get new_login_register_funnel_after_sent_reset_password_instruction_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to choose_login_method_path
      end
    end
  end
end
