require "test_helper"

describe "Reset Password", :capybara do
  include TestHelpers::SubdomainHelper
  include TestHelpers::MailHelper

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
      click_on "This is my email, send me the instructions please"

      assert_content "Madeleine we've sent you an email"

      # user recieves reset password instructions per mail
      change_password_link = find_link_in_mail(ActionMailer::Base.deliveries.last)
      visit change_password_link

      # let user pick new password
      fill_in("user_password", with: "new_password")
      fill_in("user_password_confirmation", with: "new_password")

      click_on "Change my password and sign me in"

      # user get's signed in
      assert_content "New Space"

      # mail informs user about password change
      password_changed_notify_mail = mail_content(ActionMailer::Base.deliveries.last)
      assert_match "notify you that your password has been changed", password_changed_notify_mail
    end
  end
end
