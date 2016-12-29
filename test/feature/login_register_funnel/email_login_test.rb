require "test_helper"

describe "Email Login", :capybara do
  include TestHelpers::SubdomainHelper

  # Keeping them here but for tests and especially feature tests I think DRY
  # can be an anti-pattern. Better copy-paste this instead of moving out to
  # methods, ideally there is just one test for the funnel anyway since you don't
  # want to test edge cases here. Take one user, go through the full funnel and
  # make sure it is signed in and seeing the execpted content. Use controller
  # tests to cover where the redirect lands on zero team and multiple teams.
  def normal_login_with(email:, password:)
    visit "/"
    click_on "Sign In"
    click_on "Sign in with email"

    fill_in("Email", with: email)
    click_on "This is my email"

    fill_in("Password", with: password)
    click_on "Login with my account"
  end

  def login_and_create_team_with(email:, password:)
    visit "/"
    click_on "or create Team"
    click_on "Sign in with email"

    fill_in("Email", with: email)
    click_on "This is my email"

    fill_in("Password", with: password)
    click_on "Login with my account"
  end

  # Note: these cases are covered by controller tests and I would not use these.
  # Just keeping them here for example, but I think we should remove them.
  # "Real browser" testing is slow, these two examples alone add 7s to our test
  # suite.
  context "wrong email" do
    it "shows an error message" do
      visit "/"
      click_on "Sign In"
      click_on "Sign in with email"

      fill_in("Email", with: "makingthisup")
      click_on "This is my email"

      assert_content "Email is invalid"
    end

    context "wrong password" do
      it "shows an error message" do
        normal_login_with(email: "ulf@spaces.is",
                          password: "wrongpassword")

        assert_content "The password you have entered is invalid"
      end
    end
  end
  #
  # describe "valid user authentication" do
  #   let(:email_user) { users(:ulf) }
  #   let(:user_with_several_teams) { users(:with_several_teams) }
  #   let(:user_without_team) { users(:without_team) }
  #
  #   def step_through_email_login_funnel_as(user, create_team=false)
  #     step_through_email_login_funnel_with(user.email, "password", create_team)
  #   end
  #
  #   describe "user has one team" do
  #     it "signs user into team subdomain" do
  #       step_through_email_login_funnel_as(email_user)
  #
  #       assert current_url.include? team_url({subdomain: email_user.teams.first.subdomain}.merge(url_options))
  #
  #       assert_content "Spaces"
  #     end
  #   end
  #
  #   describe "user has several teams" do
  #     it "shows all teams" do
  #       step_through_email_login_funnel_as(user_with_several_teams)
  #
  #       first_team = user_with_several_teams.teams[0].name
  #       second_team = user_with_several_teams.teams[1].name
  #
  #       assert_link "Show"
  #
  #       assert current_url.include? team_url({subdomain: email_user.teams.first.subdomain}.merge(url_options))
  #     end
  #   end
  #
  #   describe "user has no teams" do
  #     it "let's user create a team, and redirects to this team" do
  #       step_through_email_login_funnel_as(user_without_team)
  #
  #       assert current_url.include? login_register_funnel_new_team_path
  #
  #       fill_in("Name", with: "Digital Auction")
  #       fill_in("Subdomain", with: "digitalauction")
  #       find('input[name="commit"]').click
  #
  #       assert_content "Digital Auction"
  #     end
  #   end
  #
  #   describe "user clicked on create team on the landing page" do
  #     it "let's user create team, and redirects to this team" do
  #       create_team = true
  #       step_through_email_login_funnel_as(user_with_several_teams, create_team)
  #
  #       assert current_url.include? login_register_funnel_new_team_path
  #
  #       fill_in("Name", with: "Boston Law")
  #       fill_in("Subdomain", with: "bostonlaw")
  #       find('input[name="commit"]').click
  #
  #       assert current_url.include? team_url({subdomain: "bostonlaw"}.merge(url_options))
  #     end
  #   end
  # end
  #
  # describe "invalid user authentication" do
  #   let(:email_user) { users(:ulf) }
  #
  #   describe "provided wrong password" do
  #     it "shows error messages" do
  #       step_through_email_login_funnel_with(email_user.email, "invalid_password", false)
  #
  #       assert current_url.include? new_email_login_path
  #       assert_text "The password you have entered is invalid"
  #     end
  #   end
  # end
end
