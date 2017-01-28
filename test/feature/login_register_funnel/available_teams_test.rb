require "test_helper"

describe "Available Teams", :capybara do
  include TestHelpers::SubdomainHelper

  describe "shown availables teams on default subdomain" do
    let(:email_user) { users(:with_several_teams) }

    it "redirects to available team and let's user sign in" do
      # sign in into spaces teams
      visit "/landing"
      click_on "Sign In"
      click_on "Sign in with email"
      # provide email
      fill_in("Email", with: email_user.email)
      click_on "This is my email"
      # provide password
      fill_in("Password", with: "password")
      click_on "Login with my account"
      # select spaces team
      find("a[href='#{show_team_subdomain_path(teams(:spaces).subdomain)}']").click

      # assert signed in into spaces team
      assert_content "New Space"

      # go back to landing on default domain
      visit "/landing"

      # assert links to available teams are displayed
      assert_content "Spaces Organization"
      assert_content "Power Rangers"

      # click on available spaces team
      click_on "Spaces Organization"
      # spaces subdomain opens in new tab
      switch_to_window(windows.last)

      # assert user automatically signed in into spaces team
      assert_content "New Space"

      # go back to landing on default domain
      visit "/landing"

      # select power-rangers team from available teams
      click_on "Power Rangers"
      # power-rangers subdomain opens in new tab
      switch_to_window(windows.last)

      # not signed in yet into power-rangers subdomain
      # user needs to provide password
      fill_in("Password", with: "password")
      click_on "Login with my account"

      # assert signed in into power-rangers team
      assert_content "New Space"
    end
  end
end
