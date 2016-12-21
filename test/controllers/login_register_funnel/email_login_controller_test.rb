require "test_helper"

describe LoginRegisterFunnel::EmailLoginController do

  def complete_preceding_email_review_step(email)
    post review_email_address_path, params: { login_register_funnel_email_address_form: { email: email } }
  end

  describe "#new" do
    context "user completed review email address step" do
      it "works" do
        complete_preceding_email_review_step("email@spaces.is")
        debugger
        get new_email_login_path

        assert_response :success
      end
    end

    context "user did not complete review email address step" do
      it "redirects to choose sign in method step" do
        get new_email_login_path

        assert_redirected_to choose_login_method_path
      end
    end
  end


  describe "#create" do

  end
end
