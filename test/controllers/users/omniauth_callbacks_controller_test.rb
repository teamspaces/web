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
      subject.any_instance.stubs(:current_user).returns(team.users.first)
      subject.any_instance.stubs(:previous_url).returns(previous_url)
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
        get user_slack_button_omniauth_callback_url
      end

      it "redirects back with alert" do
        assert_equal I18n.t("users.omniauth_callbacks.slack_button.failed_to_save_team_authentication"), flash[:alert]
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
        get user_slack_omniauth_callback_url
      end

      it "signs in user" do
        assert_equal slack_user, @controller.current_user
      end

      it "redirects to after_sign_in_path" do
        assert_redirected_to(@controller.after_sign_in_path_for(slack_user))
      end
    end

    describe "user non existent" do
      before(:each) do
        stub_slack_identity_with(TestHelpers::Slack.identity(:unknown_user))
        get user_slack_omniauth_callback_url
      end

      it "redirects to new session path with alert" do
        assert_equal I18n.t("users.omniauth_callbacks.failed_login_using_slack"), flash[:alert]
        assert_redirected_to new_user_session_path
      end
    end
  end

  describe "register" do
    before(:each) { stub_omniauth_state_param_with("register") }

    describe "user already exists" do
      let(:slack_user) { users(:slack_user_milad) }
      before(:each) do
        stub_slack_identity_with(TestHelpers::Slack.identity(:existing_user))
        get user_slack_omniauth_callback_url
      end

      it "signs in user" do
        assert_equal slack_user, @controller.current_user
      end

      it "redirects to after_sign_in_path, with alert" do
        assert_equal I18n.t("users.omniauth_callbacks.slack.register_failed_as_user_already_exists"), flash[:alert]
        assert_redirected_to(@controller.after_sign_in_path_for(slack_user))
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

      it "signs in user" do
        get user_slack_omniauth_callback_url

        assert @controller.current_user
      end

      it "redirects to after_sign_in_path for user" do
        get user_slack_omniauth_callback_url

        assert_redirected_to(@controller.after_sign_in_path_for(@controller.current_user))
      end
    end
  end
end
