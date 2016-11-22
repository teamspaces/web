require "test_helper"

describe Users::OmniauthCallbacksController do
  subject { Users::OmniauthCallbacksController }
  let(:user) { users(:ulf) }

  before do
    # TODO: How about moving this into a helper?
    #
    # Note: This is from a failed login
    OmniAuth.config.mock_auth[:slack] = OmniAuth::AuthHash.new({
      provider: :slack,
      uid: nil,
      info: {
        nickname: nil,
        team: nil,
        user: nil,
        team_id: nil,
        user_id: nil,
        name: nil,
        email: nil,
        first_name: nil,
        last_name: nil,
        description: nil,
        image_24: nil,
        image_48: nil,
        image: nil,
        team_domain: nil,
        is_admin: nil,
        is_owner: nil,
        time_zone: nil
      },
      credentials: {
        token: "xoxp-12293384963-12293398254-54462825593-928s9d2992",
        expires: false
      },
      extra: {
        raw_info: {
          ok: false,
          error: :missing_scope,
          needed: :identify,
          provided: "identity.basic,identity.mail,identity.avatar,identity.team"
        },
        user_info: {
          ok: false,
          error: :missing_scope,
          needed: "users:read",
          provided: "identity.basic,identity.mail,identity.avatar,identity.team"
        },
        team_info: {
          ok: false,
          error: "missing_scope",
          needed: "team:read",
          provided: "identity.basic,identity.mail,identity.avatar,identity.team"
        },
        web_hook_info: {},
        bot_info: {}
      }
    })
  end

  def stub_with_hash(method, hash)
    subject.any_instance
           .stubs(method)
           .returns(hash.with_indifferent_access)
  end

  def subject_expects(method)
    subject.any_instance
           .expects(method)
  end

  def subject_stubs(method)
    subject.any_instance
           .stubs(method)
  end

  def assert_register(user)
    subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
    slack_identity_mock.stubs(:success?).returns(true)

    User::SlackLoginForm.expects(:new).returns(login_form_mock = mock)
    login_form_mock.stubs(:authenticate).returns(false)

    User::SlackRegisterForm.expects(:new).returns(register_form_mock = mock)
    register_form_mock.stubs(:save).returns(true)
    register_form_mock.stubs(:user).returns(user)
  end

  describe "#login_using_slack" do

    it "redirects and signs in" do
      subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
      slack_identity_mock.stubs(:success?).returns(true)

      User::SlackLoginForm.expects(:new).returns(login_form_mock = mock)
      login_form_mock.stubs(:authenticate).returns(true)
      login_form_mock.stubs(:user).returns(user)

      get user_slack_omniauth_callback_url

      assert_redirected_to @controller.after_sign_in_path_for(user)
    end

    context "unable to fetch identity from slack" do
      it "redirects" do
        subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
        slack_identity_mock.expects(:success?).returns(false)

        get user_slack_omniauth_callback_url
        assert_redirected_to sign_up_path
      end
    end
  end

  describe "#register_using_slack" do
    it "creates an account" do
      assert_register(user)
      get user_slack_omniauth_callback_url

      assert_redirected_to @controller.after_sign_in_path_for(user)
    end

    context "unable to register" do
      it "redirects" do
        subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
        slack_identity_mock.stubs(:success?).returns(true)

        User::SlackLoginForm.expects(:new).returns(login_form_mock = mock)
        login_form_mock.stubs(:authenticate).returns(false)

        User::SlackRegisterForm.expects(:new).returns(register_form_mock = mock)
        register_form_mock.stubs(:save).returns(false)

        get user_slack_omniauth_callback_url
        assert_redirected_to sign_up_path
      end
    end

    context "slack already connected to an account" do
      it "signs in and redirect" do
        subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
        slack_identity_mock.stubs(:success?).returns(true)

        User::SlackLoginForm.expects(:new).returns(login_form_mock = mock)
        login_form_mock.stubs(:authenticate).returns(true)
        login_form_mock.stubs(:user).returns(user)

        get user_slack_omniauth_callback_url
        assert_redirected_to @controller.after_sign_in_path_for(user)
      end
    end

    context "unable to fetch identity from slack" do
      it "redirects" do
        subject_stubs(:slack_identity).returns(slack_identity_mock = mock)
        slack_identity_mock.expects(:success?).returns(false)

        get user_slack_omniauth_callback_url
        assert_redirected_to sign_up_path
      end
    end
  end
end
