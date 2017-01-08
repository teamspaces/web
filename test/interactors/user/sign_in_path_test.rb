require "test_helper"

describe User::SignInPath, :controller do

  let(:user) { users(:sven) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:sign_in_path_helper) { UserSignInPathHelper.new(user, controller) }
  let(:shared_user_information) { LoginRegisterFunnel::SharedUserInformation }
  let(:invitation_cookie_mock) { InvitationCookieMock.new(invitations(:jonas_at_spaces)) }
  def subject(options=nil); User::SignInPath.call({ user: user, controller: controller }.merge(options.to_h)) end

  describe "invitation present" do
    it "returns accept invitation path" do
      LoginRegisterFunnel::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)

      accept_invitation_path = User::AcceptInvitationPath.call(user: user, controller: controller).path
      assert_equal accept_invitation_path, subject.path
    end
  end

  describe "team creation requested" do
    it "returns team creation url" do
      shared_user_information.any_instance.stubs(:team_creation_requested?).returns(true)

      assert_equal sign_in_path_helper.create_team_url, subject.path
    end
  end

  describe "team redirection requested" do
    it "returns team url" do
      team_to_redirect_to = user.teams.last
      path = subject(team_to_redirect_to: team_to_redirect_to).path

      assert_equal sign_in_path_helper.team_url(team_to_redirect_to), path
    end

    it "is not allowed" do
      assert false
    end
  end

  describe "sign in path for user" do
    it "returns url depending on users count" do
      assert_equal sign_in_path_helper.url_depending_on_user_teams_count, subject.path
    end
  end
end
