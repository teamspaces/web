require "test_helper"

describe "Accept Invitation", :capybara do
  include TestHelpers::SubdomainHelper

  describe "email invitation" do
    context "invited user is not yet registered" do
      let(:email_invitation_new) { invitations(:jonas_at_spaces) }

      it "user registers, automatically accepts invitation and gets redirects to team" do
        visit "/accept_invitation/#{email_invitation_new.token}"

        fill_in("First name", with: "Max")
        fill_in("Last name", with: "Mustermann")
        fill_in("Password", with: "password")
        fill_in("Password confirmation", with: "password")
        find('input[name="commit"]').click

        assert_content "Spaces Organization"
        assert_content "sign out"
        assert_content "Max"
      end
    end
  end
end
