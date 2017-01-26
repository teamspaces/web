require 'test_helper'

describe EmailConfirmationWithToken, :controller do
  let(:user) { users(:lars) }

  describe "#email_confirmation_with_token?" do
    context "valid confirmation token present" do
      it "confirms user" do
        refute true
      end

      it "redirects to path without confirmation token" do

      end
    end

    context "invalid confirmation token present" do
      it "shows notice" do

      end

      it "redirects to path without confirmation token" do

      end
    end

    context "no confirmation token present" do
      it "does nothing" do

      end
    end
  end
end
