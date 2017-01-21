require "test_helper"

describe Users::ConfirmationsController do

  describe "#show" do
    describe "valid confirmation token" do
      let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
      before(:each) { get user_confirmation_url(confirmation_token: user_with_unconfirmed_email.confirmation_token) }

      it "confirms email" do
        user_with_unconfirmed_email.reload

        assert user_with_unconfirmed_email.confirmed?
      end

      it "redirect_to sign in url for user" do
        assert_redirected_to @controller.sign_in_url_for(user: user_with_unconfirmed_email)
      end
    end

    describe "invalid confirmation token" do
      it "redirects to root url" do
        get user_confirmation_url(confirmation_token: "invalid_token")

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end
end
