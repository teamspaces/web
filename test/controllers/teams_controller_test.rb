require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }

  before(:each) { sign_in user }

  describe "#index" do
    it "works" do
      get teams_path
      assert_response :success
    end
  end

  describe "#new" do
    it "works" do
      get new_team_path
      assert_response :success
    end
  end

  describe "#show" do
    context "user is team member" do
      it "works" do
        get team_url(subdomain: team.subdomain)
        assert_response :success
      end
    end

    context "user is not team member" do
      it "refutes access" do
        sign_in users(:without_team)
        get team_url(subdomain: team.subdomain)

        assert_redirected_to landing_url(subdomain: "")
      end
    end
  end

  describe "#edit" do
    it "works" do
      get edit_team_url(subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#create" do
    context "valid" do
      it "creates team" do
        assert_difference -> { Team.count }, 1 do
          post teams_path, params: { create_team_for_user_form: { name: "bain ltd", subdomain: "baincompany" } }
        end
      end

      it "team has correct name and subdomain" do
        team_name = "barcelona"
        team_subdomain = "barca09"

        post teams_path, params: { create_team_for_user_form: { name: team_name, subdomain: team_subdomain } }
        created_team = Team.last

        assert_equal team_name, created_team.name
        assert_equal team_subdomain, created_team.subdomain
      end

      it "team has creator as primary owner" do
        post teams_path, params: { create_team_for_user_form: { name: "boston_consulting", subdomain: "bconsulting" } }

        assert_equal Team.last.primary_owner.user, user
      end

      it "redirects to team path" do
        team_subdomain = "munichdesign"

        post teams_path, params: { create_team_for_user_form: { name: "Design Munich", subdomain: team_subdomain } }

        assert_redirected_to team_url(subdomain: team_subdomain)
      end
    end

    context "invalid" do
      let(:invalid_team_for_user_form_params) { { create_team_for_user_form: { name: "Turkey Travel", subdomain: "-" } } }
      before(:each) { post teams_path, params: invalid_team_for_user_form_params }

      it "includes team errors" do
        assert_response :success
        assert controller.instance_variable_get(:@team_form).errors.present?
      end
    end
  end

  describe "#update" do
    it "works" do
      new_team_name = "Southside Security PLC"
      patch team_url(subdomain: team.subdomain), params: { team: { name: new_team_name } }

      team.reload
      assert_equal new_team_name, team.name
    end
  end

  describe "#destroy" do
    it "works" do
      assert_difference -> { Team.count }, -1 do
        delete team_url(subdomain: team.subdomain)
      end
    end
  end
end
