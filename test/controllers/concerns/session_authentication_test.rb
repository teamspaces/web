require 'test_helper'

describe SessionAuthentication, :controller do
  let(:user) { users(:lars) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }

  describe "#sign_in" do
    it "signs in user" do
      controller.sign_in(user)

      assert controller.user_signed_in?
    end
  end

  describe "#sign_out" do
    it "signs out user" do
      controller.sign_out(user)

      refute controller.user_signed_in?
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

      controller.sign_out_from_subdomain
    end
  end

  describe "#sign_out_user" do
    it "signs out current user" do

      controller.sign_out_user
    end
  end

  describe "#sign_out_users" do
    it "signs out all available users" do

      controller.sign_out_users
    end
  end
end
