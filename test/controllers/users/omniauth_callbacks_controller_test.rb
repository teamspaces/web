require "test_helper"

describe Users::OmniauthCallbacksController do
  before(:each) { Users::OmniauthCallbacksController.any_instance.stubs(:token).returns("token") }

  def stub_slack_identity_with(identity)
    Slack::FetchIdentity.stubs(:call).returns(context_mock = mock)
    context_mock.stubs(:success?).returns(true)
    context_mock.stubs(:slack_identity).returns(identity)
  end

  def stub_omniauth_state_param_with(state)
    omniauth_params = {}
    omniauth_params["state"] = state

    Users::OmniauthCallbacksController.any_instance
                                      .stubs(:omniauth_params)
                                      .returns(omniauth_params)
  end

  describe "login" do
    before(:each) { stub_omniauth_state_param_with("login") }

    describe "user exists" do
      let(:slack_user) { users(:slack_user_milad) }
      before(:each) do
        stub_slack_identity_with(Slack::Identity::Existing.new)
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
        stub_slack_identity_with(Slack::Identity::New.new)
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
        stub_slack_identity_with(Slack::Identity::Existing.new)
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
        stub_slack_identity_with(Slack::Identity::New.new)
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

  describe "fails to fetch slack identity" do
    let(:http_referer) { new_user_session_url }
    before(:each) do
      Slack::FetchIdentity.stubs(:call).returns(context_mock = mock)
      context_mock.stubs(:success?).returns(false)
    end

    it "redirects back with alert" do
      get user_slack_omniauth_callback_url, headers: { 'HTTP_REFERER': http_referer }

      assert_equal I18n.t("users.omniauth_callbacks.slack.failed_to_fetch_slack_identity"), flash[:alert]
      assert_redirected_to(http_referer)
    end
  end
end
