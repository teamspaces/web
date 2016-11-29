require "test_helper"

describe Users::OmniauthCallbacksController do
  before(:each) { Users::OmniauthCallbacksController.any_instance.stubs(:token).returns("token") }

  describe "#slack" do
    describe "new user" do
      before(:each) do
        Slack::FetchIdentity.stubs(:call).returns(context_mock = mock)
        context_mock.stubs(:success?).returns(true)
        context_mock.stubs(:slack_identity).returns(Slack::Identity::New.new)
      end

      it "creates user" do
        assert_difference -> { User.count }, 1 do
          get user_slack_omniauth_callback_url
        end
      end

      it "signs in user" do
        get user_slack_omniauth_callback_url

        assert @controller.current_user
      end

      it "redirects to after_sign_in_path" do
        get user_slack_omniauth_callback_url

        assert_redirected_to(@controller.after_sign_in_path_for(@controller.current_user))
      end
    end

    describe "existing user" do
      let(:slack_user) { users(:slack_user_milad) }
      before(:each) do
        Slack::FetchIdentity.stubs(:call).returns(context_mock = mock)
        context_mock.stubs(:success?).returns(true)
        context_mock.stubs(:slack_identity).returns(Slack::Identity::Existing.new)

        get user_slack_omniauth_callback_url
      end

      it "signs in user" do
        assert_equal slack_user, @controller.current_user
      end

      it "redirects to after_sign_in_path" do
        assert_redirected_to(@controller.after_sign_in_path_for(slack_user))
      end
    end

    describe "fetching slack identity fails" do
      let(:http_referer) { new_user_session_url }

      before(:each) do
        Slack::FetchIdentity.stubs(:call).returns(context_mock = mock)
        context_mock.stubs(:success?).returns(false)

        get user_slack_omniauth_callback_url, headers: { 'HTTP_REFERER': http_referer }
      end

      it "redirects back" do
        assert_redirected_to(http_referer)
      end

      it "shows alert message" do
        assert_equal I18n.t("users.omniauth_callbacks.failed_to_login_or_register_using_slack"), flash[:alert]
      end
    end
  end
end
