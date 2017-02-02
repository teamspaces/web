require "test_helper"

describe "Reset Password", :capybara do
  include TestHelpers::SubdomainHelper

  describe "reset password of email user" do
    let(:email_user) { users(:with_two_spaces) }

    it "let's user reset the password" do
      visit "/landing"
      click_on "Sign In"
      click_on "Sign in with email"

      fill_in("Email", with: email_user.email)
      click_on "This is my email"

      click_on "I Forgot my password, I want to reset it"

      # email input
      assert_content "We would like to send you an email"

      CustomDeviseMailer.expects(:reset_password_instructions)
                        .with(includes(email_user))
                        .returns(true)

      click_on "This is my email, send me the instructions please"

      assert_content "Madeleine we've sent you an email"
    end
  end
end
