require "test_helper"

describe "Reset Password", :capybara do
  include TestHelpers::SubdomainHelper

  def find_link_in_mail(mail)
    link = mail.body.raw_source.match(/href="(?<url>.+?)">/)[:url]
    URI(link).path
  end

  describe "reset password of email user" do
    let(:email_user) { users(:with_two_spaces) }

    it "let's user reset the password" do
      visit "/landing"
      click_on "Sign In"
      click_on "Sign in with email"

      fill_in("Email", with: email_user.email)
      click_on "This is my email"

      click_on "I Forgot my password, I want to reset it"

      assert_content "Madeleine we've sent you an email"

      change_password_link = find_link_in_mail(ActionMailer::Base.deliveries.last)
      visit change_password_link

      fill_in("Password", with: "new_password")
      fill_in("Password confirmation", with: "new_password")

      assert_content "Change my password and sign me in"

    end
  end
end
