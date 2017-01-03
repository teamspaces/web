require "test_helper"

describe LoginRegisterFunnel::SignInPathForUser, :controller do

  def setup
    get choose_login_method_url(subdomain:  ENV["DEFAULT_SUBDOMAIN"])
  end

  describe "user clicked on create team" do
    let(:user_with_several_teams) { users(:with_several_teams) }

    it "returns create team url" do
      @controller.set_user_clicked_on_create_team(true)
      url = @controller.sign_in_path_for(user_with_several_teams)

      assert url.include? login_register_funnel_new_team_url
    end
  end

  describe "user without a team" do
    let(:user_without_team) { users(:without_team) }

    it "returns create team url" do
      url = @controller.sign_in_path_for(user_without_team)

      assert url.include? login_register_funnel_new_team_url
    end
  end

  describe "user with one team" do
    let(:user_with_one_team) { users(:lars) }
    let(:team) { user_with_one_team.teams.first }

    it "returns team url" do
      url = @controller.sign_in_path_for(user_with_one_team)

      assert url.include? team_url(subdomain: team.subdomain)
    end
  end

  describe "user with several teams" do
    let(:user_with_several_teams) { users(:with_several_teams) }

    it "returns team list url" do
      url = @controller.sign_in_path_for(user_with_several_teams)

      assert url.include? login_register_funnel_list_teams_url
    end
  end
end
