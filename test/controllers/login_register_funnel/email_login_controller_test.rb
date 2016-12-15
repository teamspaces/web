require "test_helper"

describe LoginRegisterFunnel::EmailLoginController do

  def build_params(user_identification)
    { login_register_funnel_email_login_form: user_identification }
  end

  describe "#new" do
    context "completed precending funnel steps" do
      it "works" do
        get new_email_login_path

        assert_response :success
      end
    end

    context "skiped precending funnel steps" do
      it "redirects to choose sign in method step" do

      end
    end
  end

  describe "#create" do
    it "signs in user" do

    end

    it "redirects to after sign in path" do

    end
  end
end
