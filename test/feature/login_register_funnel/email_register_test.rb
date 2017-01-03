require "test_helper"

describe "Email Register", :capybara do
  include TestHelpers::SubdomainHelper

  describe "register with email address" do
    let(:user_attributes) do
      { email: "anna_moser@gmail.com",
        password: "secret",
        first_name: "Anna",
        last_name: "Moser" }
    end

    it "creates user, lets user create a team and redirects to team page" do
      visit "/"
      click_on "or create Team"

      click_on "Sign in with email"

      # enters invalid email adress
      fill_in("Email", with: "netherlands")
      click_on "This is my email"

      assert_content "Email is invalid"

      # enters valid email address
      fill_in("Email", with: user_attributes[:email])
      click_on "This is my email"

      # enters incomplete user information
      fill_in("First name", with: user_attributes[:first_name])
      fill_in("Password", with: user_attributes[:password])
      find('input[name="commit"]').click

      assert_content "Last name can't be blank"
      assert_content "Password confirmation doesn't match Password"

      # enters complete user information
      fill_in("First name", with: user_attributes[:first_name])
      fill_in("Last name", with: user_attributes[:last_name])
      fill_in("Password", with: user_attributes[:password])
      fill_in("Password confirmation", with: user_attributes[:password])
      find('input[name="commit"]').click

      # enters incomplete team information
      fill_in("Name", with: "Dean and Anders")
      find('input[name="commit"]').click

      assert_content "Subdomain can't be blank"

      # enters complete team information
      fill_in("Name", with: "Dean and Anders")
      fill_in("Subdomain", with: "deanandanders")
      find('input[name="commit"]').click

      assert_content "sign out"
      assert_content user_attributes[:email]
      assert_content "Team"
    end
  end
end
