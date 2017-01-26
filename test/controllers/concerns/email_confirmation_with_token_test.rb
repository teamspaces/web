require 'test_helper'

describe EmailConfirmationWithToken, :controller do
  let(:unconfirmed_user) { users(:with_unconfirmed_email) }

  describe "#email_confirmation_with_token?" do
    describe "valid confirmation token present" do
      before(:each) do
        get root_url(confirmation_token: unconfirmed_user.confirmation_token)
      end

      it "confirms user" do
        unconfirmed_user.reload

        assert unconfirmed_user.confirmed?
      end

      it "redirects to path without confirmation token" do
        assert_redirected_to root_url
        assert_nil flash[:notice]
      end
    end

    describe "invalid confirmation token present" do
      before(:each) do
        get root_url(confirmation_token: "invalid_token")
      end

      it "shows notice" do
        assert_equal "Confirmation token is invalid", flash[:notice]
      end

      it "redirects to path without confirmation token" do
        assert_redirected_to root_url
      end
    end

    describe "no confirmation token present" do
      it "does nothing" do
        get root_url(confirmation_token: nil)

        assert_nil flash[:notice]
      end
    end
  end
end
