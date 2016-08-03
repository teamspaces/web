require "test_helper"

describe Users::OmniauthCallbacksController do
  subject { Users::OmniauthCallbacksController }

  def stub_omniauth_params(hash)
    stub_with_hash(:omniauth_params, hash)
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

  describe "#slack" do
    describe "#login_request?" do
      let(:omniauth_params) { { state: "login" } }
      it "calls #login_using_slack" do
        stub_omniauth_params(omniauth_params)
        subject_expects(:login_using_slack)
        get user_slack_omniauth_callback_url
      end
    end

    describe "#register_request?" do
      let(:omniauth_params) { { state: "register" } }
      it "calls #register_using_slack" do
        stub_omniauth_params(omniauth_params)
        subject_expects(:register_using_slack)
        get user_slack_omniauth_callback_url
      end
    end

    describe "state is unknown" do
      let(:omniauth_params) { { state: "unknown" } }
      it "errors" do
        stub_omniauth_params(omniauth_params)
        get user_slack_omniauth_callback_url
        assert_response :unprocessable_entity
      end
    end
  end

  describe "#login_using_slack" do
    let(:omniauth_params) { { state: "login" } }
    let(:user) { users(:ulf) }

    it "signs in and redirects" do
      stub_omniauth_params(omniauth_params)
      subject_expects(:uid).returns("12345")

      login_form_mock = mock
      User::SlackLoginForm.expects(:new).returns(login_form_mock)
      login_form_mock.stubs(:login).returns(true)
      login_form_mock.stubs(:user).returns(user)

      get user_slack_omniauth_callback_url
    end

    # TODO: Why not `context`?
    describe "unable to login" do
      it "redirects and displays an error" do
        skip
      end
    end
  end

  describe "#register_using_slack" do
    it "creates an account and redirects" do
      skip
    end

    # TODO: Why not `context`?
    describe "slack already connected to an account" do
      it "redirects and sign in" do
        skip
      end
    end
  end

  describe "#failure" do
    it "redirects" do
      skip
    end
  end
end
