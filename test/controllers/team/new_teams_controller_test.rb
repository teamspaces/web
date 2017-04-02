require "test_helper"

describe Team::NewTeamsController do
  let(:user) { users(:lars) }
  let(:available_user) { users(:ulf) }
  let(:unavailable_user) { users(:sven) }
  before(:each) { sign_in user }
  before(:each) do
    ApplicationController.any_instance
                         .stubs(:available_users)
                         .returns(available_users_mock = mock)

    available_users_mock.stubs(:users)
                        .returns([user, available_user])
  end

  describe "#index" do
    it "works" do
      get team_new_teams_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
      assert_response :success
    end
  end

  describe "#new" do
    context "with available_user" do
      it "works" do
        get new_team_new_team_url(available_user, subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
        assert_response :success
      end
    end

    context "with unavailable_user" do
      it "works" do
        get new_team_new_team_url(unavailable_user, subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
        assert_response :success
      end
    end
  end

  describe "create" do
    describe "valid team params" do
      def post_valid_params
        valid_params = { user_id: available_user.id, team: { name: "bain ltd", subdomain: "baincompany" } }

        post team_new_teams_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"]), params: valid_params
      end

      it "creates a team" do
        assert_difference -> { Team.count }, 1 do
          post_valid_params
        end
      end

      it "redirects to sign_in_url for user and created team" do
        post_valid_params

        assert_redirected_to @controller.sign_in_url_for(user: available_user, created_team_to_redirect_to: Team.last)
      end
    end

    context "invalid team params" do
      it "works" do

      end
    end
  end
end


