require "test_helper"

describe User::SignInPath, :controller do

  let(:user) { users(:sven) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:sign_in_url_for_user) { SignInUrlForUser.new(user, controller) }
  let(:shared_user_information) { LoginRegisterFunnel::BaseController::SharedUserInformation }
  let(:invitation_cookie_mock) { InvitationCookieMock.new(invitations(:jonas_at_spaces)) }
  def subject(options=nil); User::SignInPath.call({ user: user, controller: controller }.merge(options.to_h)) end

  describe "invitation present" do
    it "returns accept invitation path" do
      LoginRegisterFunnel::BaseController::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)

      accept_invitation_path = User::AcceptInvitationPath.call(user: user, controller: controller).path
      assert_equal accept_invitation_path, subject.path
    end
  end

  describe "team creation requested" do
    it "returns team creation url" do
      shared_user_information.any_instance.stubs(:team_creation_requested?).returns(true)

      assert_equal sign_in_url_for_user.create_team_url, subject.path
    end
  end

  describe "team redirection requested" do

    context "user is allowed to access team" do
      let(:user_team) { user.teams.last }

      it "returns team url" do
        path = subject(team_to_redirect_to: user_team).path

        assert_equal sign_in_url_for_user.team_url(user_team), path
      end
    end

    context "user is not allowed to access team" do
      let(:external_team) { teams(:with_two_spaces) }

      it "does not return team url" do
        path = subject(team_to_redirect_to: external_team).path

        assert_not_equal sign_in_url_for_user.team_url(external_team), path
      end
    end
  end

  describe "sign in path for user" do
    it "returns url depending on users count" do
      assert_equal sign_in_url_for_user.url_depending_on_user_teams_count, subject.path
    end
  end
end
