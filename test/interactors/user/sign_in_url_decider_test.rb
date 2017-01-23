require "test_helper"

describe User::SignInUrlDecider, :controller do

  let(:user) { users(:sven) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:sign_in_url_for_user) { LoginRegisterFunnel::BaseController::SignInUrlForUser.new(user, controller) }
  let(:shared_user_information) { LoginRegisterFunnel::BaseController::SharedUserInformation }
  let(:invitation_cookie_mock) { InvitationCookieMock.new(invitations(:jonas_at_spaces)) }
  before(:each) { GenerateLoginToken.stubs(:call).returns("user_login_token") }

  def subject(options=nil)
    User::SignInUrlDecider.call({ user: user, controller: controller }.merge(options.to_h))
  end

  describe "invitation present" do
    it "returns accept invitation url" do
      LoginRegisterFunnel::BaseController::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)

      accept_invitation_url = User::AcceptInvitationURL.call(user: user, controller: controller).url
      assert_equal accept_invitation_url, subject.url
    end
  end

  describe "team creation requested" do
    it "returns team creation url" do
      shared_user_information.any_instance
                             .stubs(:team_creation_requested?)
                             .returns(true)

      assert_equal sign_in_url_for_user.create_team_url, subject.url
    end
  end

  describe "redirection to created team requested" do
    let(:created_team) { user.teams.last }

    it "returns team url" do
      url = subject(created_team_to_redirect_to: created_team).url

      assert_equal sign_in_url_for_user.team_url(created_team), url
    end
  end

  describe "team redirection requested" do
    context "user is allowed to access team" do
      let(:user_team) { user.teams.last }

      it "returns team spaces url" do
        url = subject(team_to_redirect_to: user_team).url

        assert_equal sign_in_url_for_user.team_spaces_url(user_team), url
      end
    end

    context "user is not allowed to access team" do
      let(:external_team) { teams(:with_two_spaces) }

      it "does not return team spaces url" do
        url = subject(team_to_redirect_to: external_team).url

        assert_not_equal sign_in_url_for_user.team_spaces_url(external_team), url
      end
    end
  end

  describe "sign in url for user" do
    it "returns url depending on users count" do
      assert_equal sign_in_url_for_user.url_depending_on_user_teams_count, subject.url
    end
  end
end
