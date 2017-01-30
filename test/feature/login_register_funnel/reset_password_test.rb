require "test_helper"

describe "Reset Password", :capybara do
  include TestHelpers::SubdomainHelper

  def mail_content(mail)
    mail.body.raw_source
  end

  def find_link_in_mail(mail)
    link = mail_content(mail).match(/href="(?<url>.+?)">/)[:url]
    uri = URI(link)
    "#{uri.path}?#{uri.query}"
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

      fill_in("user_password", with: "new_password")
      fill_in("user_password_confirmation", with: "new_password")

      click_on "Change my password and sign me in"

      assert_content "New Space"

      latest_mail = mail_content(ActionMailer::Base.deliveries.last)

      assert_match "hola", latest_mail
    end
  end
end
