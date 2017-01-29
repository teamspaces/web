require 'test_helper'

describe SessionAuthentication, :controller do
  let(:unconfirmed_user) { users(:with_unconfirmed_email) }

  describe "#sign_in" do
    it "signs in user" do

    end
  end

  describe "#sign_out" do
    it "signs out user" do

    end
  end

  describe "#authenticate_user!" do
    context "user is signed in" do
      it "does nothing" do
      end
    end

    context "user not signed in" do
      it "redirects to landing" do

      end
    end

    context "user is signed in on another subdomain" do
      it "signs in user" do

      end
    end
  end

  describe "#sign_out_from_subdomain" do
    it "invalidates session" do

    end
  end

  describe "#sign_out_user" do
    it "signs out current user" do

    end
  end

  describe "#sign_out_users" do
    it "signs out all available users" do

    end
  end
end
