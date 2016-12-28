require "test_helper"

describe "Email Register", :capybara do
  include TestHelpers::SubdomainHelper

  def step_through_email_register_funnel_with(user_attributes)
    proceed_to_register_form(user_attributes)
    fill_in_register_form(user_attributes)
  end

  def proceed_to_register_form(user_attributes)
    visit "/"
    click_on "or create Team"

    assert current_url.include? choose_login_method_path
    click_on "Sign in with email"

    assert current_url.include? new_review_email_address_path
    fill_in("Email", with: user_attributes[:email])
    click_on "This is my email"
  end

  def fill_in_register_form(user_attributes)
    assert current_url.include? new_email_register_path

    fill_in("First name", with: user_attributes[:first_name])
    fill_in("Last name", with: user_attributes[:last_name])
    fill_in("Password", with: user_attributes[:password])
    fill_in("Password confirmation", with: user_attributes[:password])

    find('input[name="commit"]').click
  end

  describe "valid user attributes" do
    let(:valid_user_attributes) do
      { email: "anna_moser@gmail.com", password: "secret",
        first_name: "Anna", last_name: "Moser" }
    end

    it "register's user and let's user create a team" do
      assert_difference -> { User.count }, 1 do
        step_through_email_register_funnel_with(valid_user_attributes)
      end

      assert current_url.include? login_register_funnel_new_team_path

      fill_in("Name", with: "Siberian Deer")
      fill_in("Subdomain", with: "siberiandeer")
      find('input[name="commit"]').click

      assert current_url.include? team_url({subdomain: "siberiandeer"}.merge(url_options))
    end
  end

  describe "invalid user attributes" do
    let(:invalid_user_attributes) do
      { email: "sophia_hausler@gmail.com", password: "secret",
        first_name: nil, last_name: nil }
    end

    it "prevent's registration and shows error messages" do
      step_through_email_register_funnel_with(invalid_user_attributes)

      assert current_url.include? new_email_register_path

      assert_text "First name can't be blank"
      assert_text "Last name can't be blank"
    end
  end

  describe "email already exists for slack account" do
    let(:slack_user) { users(:slack_user_milad) }

    it "shows the option to sign in with slack" do
      proceed_to_register_form({email: slack_user.email})

      assert_link "Login with your Slack Account"
    end
  end
end
