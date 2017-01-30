require "test_helper"

describe LoginRegisterFunnel::EmailLoginController do
  let(:email_user) { users(:with_several_teams) }

  def complete_preceding_email_review_step(email)
    LoginRegisterFunnel::BaseController::SharedUserInformation.any_instance
                                              .stubs(:reviewed_email_address)
                                              .returns(email)

    GenerateLoginToken.stubs(:call).returns("user_login_token")
  end

  def build_params(user_identification)
    { login_register_funnel_email_login_form: user_identification }
  end

  describe "#new" do
    context "user completed review email address step" do
      it "responds successfully" do
        complete_preceding_email_review_step(email_user.email)
        get new_email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user did not complete review email address step" do
      it "redirects to choose sign in method step" do
        get new_email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to choose_login_method_path
      end
    end
  end

  describe "#create" do
    before(:each) { complete_preceding_email_review_step(email_user.email) }

    describe "valid username, password" do
      it "redirects to sign in url for user" do
        post email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params({ email: email_user.email, password: "password" })

        assert_redirected_to @controller.sign_in_url_for(user: email_user)
      end

      context "user signs in from team subdomain" do
        it "redirects to sign in url for user with team redirection" do
          subdomain_team = email_user.teams.last
          post email_login_url(subdomain: subdomain_team.subdomain), params: build_params({ email: email_user.email, password: "password" })

          assert_redirected_to @controller.sign_in_url_for(user: email_user, team_to_redirect_to: subdomain_team)
        end
      end
    end

    context "invalid username, password" do
      it "responds" do
        post email_login_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: build_params({ email: email_user.email, password: "wrong" })

        assert_response :success
      end
    end
  end
end
