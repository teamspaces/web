require "test_helper"

describe "Accept Invitation", :capybara do
  include TestHelpers::SubdomainHelper

  before(:each) do
    interactor_mock = mock
    interactor_mock.stubs(:success?).returns(true)

    User::Avatar::AttachGeneratedAvatar.stubs(:call)
                                       .returns(interactor_mock)
  end

  describe "email invitation" do
    describe "invited user is not yet registered" do
      let(:email_invitation_new) { invitations(:jonas_at_spaces) }

      it "user gets to register, automatically accepts invitation and gets redirects to team" do
        visit "/accept_invitation/#{email_invitation_new.token}"

        fill_in("First name", with: "Max")
        fill_in("Last name", with: "Mustermann")
        fill_in("Password", with: "password")
        fill_in("Password confirmation", with: "password")
        find('input[name="commit"]').click

        assert_content "New space"
      end
    end
  end
end
