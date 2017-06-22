require "test_helper"

describe Accounts::NewTeamController do
  let(:user) { users(:lars) }
  let(:available_user) { users(:ulf) }
  let(:unavailable_user) { users(:sven) }
  before(:each) do
    sign_in user

    ApplicationController.any_instance
                         .stubs(:available_users)
                         .returns(available_users_mock = mock)

    available_users_mock.stubs(:users)
                        .returns([user, available_user])

    GenerateLoginToken.stubs(:call).returns("user_login_token")
  end

  describe "#index" do
    it "works" do
      get choose_account_for_new_team_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
      assert_response :success
    end
  end

  describe "#new" do
    context "with available_user" do
      it "works" do
        get new_team_for_account_url(available_user, subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
        assert_response :success
      end
    end

    context "with unavailable_user" do
      it "raises authorization error" do
        assert_raise Pundit::NotAuthorizedError do
          get new_team_for_account_url(unavailable_user, subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
        end
      end
    end
  end

  describe "create" do
    let(:valid_team_params) { { user_id: available_user.id, team: { name: "bain ltd", subdomain: "baincompany" } } }
    let(:invalid_team_params) { { user_id: available_user.id, team: { name: "bain ltd" } } }
    let(:unavailable_user_team_params) { { user_id: unavailable_user.id, team: { name: "bain ltd", subdomain: "baincompany" } } }

    def post_params params
      post team_for_account_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"]), params: params
    end

    context "with valid team params" do
      it "creates a team" do
        assert_difference -> { Team.count }, 1 do
          post_params valid_team_params
        end
      end

      it "redirects to sign_in_url for user and created team" do
        post_params valid_team_params

        assert_redirected_to @controller.sign_in_url_for(user: available_user, created_team_to_redirect_to: Team.last)
      end
    end

    context "with invalid team params" do
      it "works" do
        assert_difference -> { Team.count }, 0 do
          post_params invalid_team_params
          assert_response :success
        end
      end
    end

    context "with unavailable user" do
      it "raises authorization error" do
        assert_raise Pundit::NotAuthorizedError do
          post_params unavailable_user_team_params
        end
      end
    end
  end
end
