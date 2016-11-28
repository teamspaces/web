require "test_helper"

describe Users::OmniauthCallbacksController do
  before(:each) { Users::OmniauthCallbacksController.any_instance.stubs(:token).returns("token") }

  describe "#slack" do
    context "finds or creates user" do
      let(:slack_user) { users(:slack_user_milad) }

      before(:each) do
        FindOrCreateUserWithSlack.expects(:call).returns(context_mock = mock)
        context_mock.stubs(:success?).returns(true)
        context_mock.stubs(:user).returns(slack_user)

        get user_slack_omniauth_callback_url
      end

      it "signs in user" do
        assert_equal slack_user, @controller.current_user
      end

      it "redirects to after_sign_in_path" do
        assert_redirected_to(@controller.after_sign_in_path_for(slack_user))
      end
    end

    context "fails to find or create user" do
      let(:http_referer) { new_user_session_url }

      before(:each) do
        FindOrCreateUserWithSlack.expects(:call).returns(context_mock = mock)
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
