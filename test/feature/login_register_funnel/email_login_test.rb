require "test_helper"

describe "Email Login", :capybara do
  include TestHelpers::SubdomainHelper

  describe "login with email account" do
    let(:email_user) { users(:with_two_spaces) }

    it "signs in user and shows team page" do
      visit "/"
      click_on "Sign In"
      click_on "Sign in with email"

      fill_in("Email", with: email_user.email)
      click_on "This is my email"

      # enters wrong password
      fill_in("Password", with: "wrong_password")
      click_on "Login with my account"

      assert_content "The password you have entered is invalid"

      # enters correct password
      fill_in("Password", with: "password")
      click_on "Login with my account"

      assert_content "sign out"
      assert_content email_user.email
      assert_content "Team"
    end
  end
end
