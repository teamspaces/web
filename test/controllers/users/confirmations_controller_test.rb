require "test_helper"

describe Users::ConfirmationsController do

  describe "#show" do
    describe "valid confirmation token" do
      let(:user_without_confirmed_email) { users(:email_not_yet_confirmed) }
      before(:each) { get user_confirmation_url(confirmation_token: user_without_confirmed_email.confirmation_token) }

      it "confirms email" do
        user_without_confirmed_email.reload

        assert user_without_confirmed_email.confirmed?
      end

      it "redirect_to sign in url for user" do
        assert_redirected_to @controller.sign_in_url_for(user: user_without_confirmed_email)
      end
    end

    describe "invalid confirmation token" do
      context "already confirmed" do

      end

      context "not existent" do

      end

      context "invalid to old" do

      end
    end
  end
end
