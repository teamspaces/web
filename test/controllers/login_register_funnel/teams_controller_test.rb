require "test_helper"

describe LoginRegisterFunnel::TeamsController do
  let(:user) { users(:with_several_teams) }

  describe "#new" do
    context "user signed in" do
      it "works" do
        sign_in(user)
        get login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user not signed in" do
      it "redirects" do
        get login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to landing_path
      end
    end
  end

  describe "#create" do
    before(:each) { sign_in(user) }

    describe "valid team attributes" do
      def post_valid_team_attributes
        valid_team_attributes = { create_team_for_user_form: { name: "bain ltd", subdomain: "baincompany" } }

        post login_register_funnel_create_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: valid_team_attributes
      end

      it "creates team" do
        assert_difference -> { Team.count }, 1 do
          post_valid_team_attributes
        end
      end

      it "signs user out from default subdomain" do
        post_valid_team_attributes

        assert_nil @controller.current_user
      end

      it "redirects user to team path" do
        post_valid_team_attributes

        assert response.redirect_url.include? team_url(subdomain: "baincompany")
      end
    end

    describe "invalid team attributes" do
      def post_invalid_team_attributes
        invalid_team_attributes = { create_team_for_user_form: { name: "Turkey Travel", subdomain: "-" } }

        post login_register_funnel_create_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: invalid_team_attributes
      end

      it "renders new, includes error messages" do
        post_invalid_team_attributes

        assert controller.instance_variable_get(:@team_form).errors.present?
        assert_response :success
      end
    end
  end

  describe "#show" do
    let(:team_subdomain) { user.teams.first.subdomain }

    it "redirects and signs user into team subdomain" do
      sign_in(user)
      get show_team_subdomain_url(team_subomain: team_subdomain, subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert response.redirect_url.include?(team_url(subdomain: team_subdomain))
    end
  end

  describe "#index" do
    before(:each) do
      sign_in(user)
      get login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end

    it { assert_response :success }
  end
end
