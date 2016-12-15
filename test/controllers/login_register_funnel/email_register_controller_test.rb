require "test_helper"

describe LoginRegisterFunnel::EmailRegisterController do

  def fulfill_preceding_email_review_step(email)
    post review_email_address_path, params: { login_register_funnel_email_address_form: { email: email } }
  end

  describe "#new" do
    context "completed precending funnel steps" do
      it "works" do
        fulfill_preceding_email_review_step("email@spaces.is")
        get new_email_register_path

        assert_response :success
      end
    end

    context "skiped precending funnel steps" do
      it "redirects to choose sign in method step" do
        get new_email_register_path

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    let(:email) { "justwannagethigh@spaces.is" }
    before(:each) { fulfill_preceding_email_review_step(email) }
    before(:each) do

    end

    it "creates user" do

    end

    it "signs in user" do

    end

    it "redirects to after sign in path" do

    end
  end
end
