require "test_helper"

describe "Email Login", :integration do
  let(:email_user) { users(:ulf) }
  let(:user_with_several_teams) { users(:with_several_teams) }
  let(:user_without_team) { users(:without_team) }
  let(:url_options) { { domain: "lvh.me", port: Capybara.current_session.server.port } }

  def step_through_email_login_funnel_with(email, password, create_team)
    visit "/"

    if create_team
      click_on "or create Team"
    else
      click_on "Sign In"
    end

    assert current_url.include? choose_login_method_path
    click_on "Sign in with email"

    assert current_url.include? new_review_email_address_path
    fill_in("Email", with: email)
    click_on "This is my email"

    assert current_url.include? new_email_login_path
    fill_in("Password", with: password)
    click_on "Login with my account"
  end

  describe "valid user authentication" do
    def step_through_email_login_funnel_as(user, create_team=false)
      step_through_email_login_funnel_with(user.email, "password", create_team)
    end

    context "user has one team" do
      it "signs user into team subdomain" do
        step_through_email_login_funnel_as(email_user)

        assert current_url.include? team_url({subdomain: email_user.teams.first.subdomain}.merge(url_options))
      end
    end

    context "user has several teams" do
      it "let's user choose team" do
        step_through_email_login_funnel_as(user_with_several_teams)

        assert current_url.include? list_teams_path
        click_on("Show", match: :first)

        assert current_url.include? team_url({subdomain: email_user.teams.first.subdomain}.merge(url_options))
      end
    end

    context "user has no teams" do
      it "let's user create a team" do
        step_through_email_login_funnel_as(user_without_team)

        assert current_url.include? login_register_funnel_new_team_path

        fill_in("Name", with: "Digital Auction")
        fill_in("Subdomain", with: "digitalauction")
        submit_form

        assert current_url.include? team_url({subdomain: "digitalauction"}.merge(url_options))
      end
    end

    context "user clicked on create" do
      it "let's user create a team" do
        create_team = true
        step_through_email_login_funnel_as(user_with_several_teams, create_team)

        assert current_url.include? login_register_funnel_new_team_path

        fill_in("Name", with: "Boston Law")
        fill_in("Subdomain", with: "bostonlaw")
        submit_form

        assert current_url.include? team_url({subdomain: "bostonlaw"}.merge(url_options))
      end
    end
  end

  describe "invalid user authentication" do
    context "provided wrong password" do
      it "shows error messages" do
        step_through_email_login_funnel_with(email_user.email, "invalid_password", false)

        assert current_url.include? new_email_login_path
        assert_text "translation missing: en.users.login.errors.wrong_password"
      end
    end
  end
end
