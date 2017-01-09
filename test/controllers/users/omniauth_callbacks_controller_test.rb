require "test_helper"

describe Users::OmniauthCallbacksController do
  subject { Users::OmniauthCallbacksController }
  before(:each) { subject.any_instance.stubs(:token).returns("token") }

  def stub_slack_identity_with(identity)
    Users::OmniauthCallbacksController.any_instance
                                      .stubs(:slack_identity)
                                      .returns(identity)
  end

  def stub_omniauth_params_with(params)
    subject.any_instance.stubs(:omniauth_params).returns(params)
  end

  def stub_omniauth_state_param_with(state)
    omniauth_params = {}
    omniauth_params["state"] = state

    subject.any_instance.stubs(:omniauth_params).returns(omniauth_params)
  end

  describe "#slack_button" do
    let(:team) { teams(:power_rangers) }
    let(:token) { "token" }
    let(:previous_url) { "team.spaces.is" }
    before(:each) do
      stub_omniauth_params_with({team_id: team.id}.stringify_keys)
      subject.any_instance.stubs(:previous_url).returns(previous_url)
      stub_slack_identity_with(TestHelpers::Slack.identity(:existing_user))
    end

    describe "valid" do
      it "saves team authentication" do
        assert_difference -> { TeamAuthentication.count }, 1 do
          get user_slack_button_omniauth_callback_url
        end
      end

      it "redirects back" do
        get user_slack_button_omniauth_callback_url
        assert_redirected_to previous_url
      end
    end

    describe "invalid" do
      before(:each) do
        subject.any_instance.stubs(:token).returns(nil)
        stub_slack_identity_with(TestHelpers::Slack.identity(:unknown_user))
        get user_slack_button_omniauth_callback_url
      end

      it "redirects back with alert" do
        assert_match "Failed to connect team to Slack. Please try again", flash[:alert]
        assert_redirected_to previous_url
      end
    end
  end

  describe "login" do
    before(:each) { stub_omniauth_state_param_with("login") }

    describe "user exists" do
      let(:slack_user) { users(:slack_user_milad) }
      before(:each) do
        stub_slack_identity_with(TestHelpers::Slack.identity(:existing_user))
      end

      it "redirects to sign_in_path_for user" do
        get user_slack_omniauth_callback_url

        assert_redirected_to User::SignInPath.call(user: slack_user, controller: @controller).path
      end

      describe "team redirection requested" do
        it "redirects to sign_in_path_for users team" do
          team = slack_user.teams.first
          stub_omniauth_params_with({state: "login", team_id: team.id}.with_indifferent_access)
          get user_slack_omniauth_callback_url

          #yeah

          assert_redirected_to(@controller.sign_in_path_for(slack_user, team))
        end
      end
    end

    describe "user non existent" do
      before(:each) do
        stub_slack_identity_with(TestHelpers::Slack.identity(:unknown_user))
        get user_slack_omniauth_callback_url
      end

      it "redirects to slack register url with alert" do
        assert_match "Login failed. Please register first with your Slack Account", flash[:alert]
        assert_redirected_to slack_register_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  describe "register" do
    before(:each) { stub_omniauth_state_param_with("register") }

    describe "user already exists" do
      let(:slack_user) { users(:slack_user_milad) }

      it "redirects to sign_in_path for user" do
        stub_slack_identity_with(TestHelpers::Slack.identity(:existing_user))
        get user_slack_omniauth_callback_url

        assert_redirected_to User::SignInPath.call(user: slack_user, controller: @controller).path
      end
    end

    describe "new user" do
      before(:each) do
        stub_slack_identity_with(TestHelpers::Slack.identity(:unknown_user))
      end

      it "creates user" do
        assert_difference ->{ User.count }, 1 do
          get user_slack_omniauth_callback_url
        end
      end

      it "redirects to after_sign_in_path for user" do
        get user_slack_omniauth_callback_url

        assert_redirected_to User::SignInPath.call(user: User.last, controller: @controller).path
      end
    end
  end

  describe "user accepts invitation" do
    let(:slack_user) { users(:slack_user_milad) }
    let(:slack_user_invitation) { invitations(:slack_user_milad_invitation) }
    let(:invitation_cookie_mock) { InvitationCookieMock.new(slack_user_invitation) }

    it "adds user as team member to host team" do
      stub_omniauth_state_param_with("register")
      stub_slack_identity_with(TestHelpers::Slack.identity(:existing_user))
      LoginRegisterFunnel::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)

      get user_slack_omniauth_callback_url

      assert_includes slack_user.teams, slack_user_invitation.team
    end
  end
end
