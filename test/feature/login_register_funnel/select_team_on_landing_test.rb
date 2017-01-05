require "test_helper"

describe "Select Team On Landing", :capybara do
  include TestHelpers::SubdomainHelper

  describe "select team on landing page" do
    let(:email_user) { users(:with_several_teams) }

    it "list teams on landing, can select team, signs in into team" do
      visit "/landing"
      click_on "Sign In"
      click_on "Sign in with email"

      fill_in("Email", with: email_user.email)
      click_on "This is my email"

      # enters correct password
      fill_in("Password", with: "password")
      click_on "Login with my account"

      # select team
      find("a[href='#{show_team_subdomain_path(teams(:spaces).subdomain)}']").click

      assert_content "sign out"
      assert_content email_user.email
      assert_content "Spaces Organization"
      assert_content "Team"

      # visit default-subdomain landing
      visit "/landing"

      # list links to teams
      assert_content "Spaces Organization"
      assert_content "Power Rangers"

      # open spaces organization
      click_on "Spaces Organization"
      switch_to_window(windows.last)

      # already logged in
      assert_content "sign out"
      assert_content email_user.email
      assert_content "Spaces Organization"
      assert_content "Team"

      # visit default-subdomain landing
      visit "/landing"

      # list links to teams
      assert_content "Spaces Organization"
      assert_content "Power Rangers"

      # open power rangers team
      click_on "Power Rangers"
      switch_to_window(windows.last)

      # not signed in, needs to input password first
      fill_in("Password", with: "password")
      click_on "Login with my account"

      # sees power rangers content
      assert_content "sign out"
      assert_content email_user.email
      assert_content "Power Rangers"
      assert_content "Team"

    end
  end
end
