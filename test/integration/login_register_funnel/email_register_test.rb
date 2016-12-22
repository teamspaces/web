require "test_helper"

describe "Email Register", :integration do

  def step_through_email_register_funnel_with(user_attributes)
    visit "/"
    click_on "or create Team"

    assert current_url.include? choose_login_method_path
    click_on "Sign in with email"

    assert current_url.include? new_review_email_address_path
    fill_in("Email", with: user_attributes[:email])
    click_on "This is my email"

    assert current_url.include? new_email_register_path

    fill_in("First name", with: user_attributes[:first_name])
    fill_in("Last name", with: user_attributes[:last_name])
    fill_in("Password", with: user_attributes[:password])
    fill_in("Password confirmation", with: user_attributes[:password])

    submit_form
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

      assert current_url.include? new_team_ree_path

      fill_in("Name", with: "Siberian Deer")
      fill_in("Subdomain", with: "siberiandeer")
      submit_form

      assert current_url.include? team_url(subdomain: "siberiandeer")
    end
  end

  describe "invalid user attributes" do
    let(:invalid_user_attributes) do
      { email: "anna_moser@gmail.com", password: "secret",
        first_name: nil, last_name: nil }
    end

    it "shows error messages" do
      step_through_email_register_funnel_with(invalid_user_attributes)

      assert_text "First name can't be blank"
      assert_text "Last name can't be blank"
    end
  end
end
