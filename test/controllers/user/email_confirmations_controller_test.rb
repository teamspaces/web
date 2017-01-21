require 'test_helper'

describe User::EmailConfirmationsController do
  let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
  let(:team) { user_with_unconfirmed_email.teams.first }
  before(:each) { sign_in user_with_unconfirmed_email }

  describe "user already confirmed" do
    let(:user_with_confirmed_email) { users(:ulf) }

    it "redirects to root" do
      sign_in user_with_confirmed_email

      get new_user_email_confirmation_url(subdomain: user_with_confirmed_email.teams.first.subdomain)

      assert_redirected_to root_subdomain_url
    end
  end

  describe "#new" do
    it "works" do
      get new_user_email_confirmation_url(subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#create" do
    it "sends email confirmation mail" do
      user_with_unconfirmed_email.expects(:send_confirmation_instructions).once

      post user_email_confirmation_url(subdomain: team.subdomain)
    end

    it "redirects to email confirmation page" do
      post user_email_confirmation_url(subdomain: team.subdomain)

      assert_redirected_to new_user_email_confirmation_path
    end
  end

  describe "#update" do
    context "valid attributes" do
      it "updates email" do
        patch user_email_confirmation_url(subdomain: team.subdomain), params: { user: { email: "new_email@nl.com" } }

        assert_equal "new_email@nl.com", user_with_unconfirmed_email.email
      end

      it "sends email confirmation" do
        user_with_unconfirmed_email.expects(:send_confirmation_instructions).once

        patch user_email_confirmation_url(subdomain: team.subdomain), params: { user: { email: "hello@nl.com" } }
      end
    end

    context "invalid attributes" do
      it "works" do
        patch user_email_confirmation_url(subdomain: team.subdomain), params: { user: { email: "invalid" } }

        assert_response :success
      end
    end
  end
end
