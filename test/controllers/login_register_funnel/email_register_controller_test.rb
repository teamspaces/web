require "test_helper"


describe LoginRegisterFunnel::EmailRegisterController do

  describe "#new" do
    context "completed precending funnel steps" do
      it "works" do
        get new_email_register_path

        assert_response :success
      end
    end

    context "skiped precending funnel steps" do
      it "redirects to choose sign in method step" do

      end
    end
  end

  describe "#create" do
    it "creates user" do

    end

    it "signs in user" do

    end

    it "redirects to after sign in path" do

    end
  end
end
