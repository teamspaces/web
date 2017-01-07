require "test_helper"

describe LoginRegisterFunnel::SignInPathForUser, :controller do

  def setup
    get choose_login_method_url(subdomain:  ENV["DEFAULT_SUBDOMAIN"])
  end

  let(:user) { users(:with_several_teams) }
  let(:user_team) { user.teams.first }

  it "adds user to available users on sign in" do
    AvailableUsersCookie.any_instance.expects(:add).with(user)

    @controller.sign_in_path_for(user)
  end

  describe "user requestes team creation" do
    it "returns create team url" do
      LoginRegisterFunnel::SharedUserInformation.any_instance
                                                .stubs(:team_creation_requested?)
                                                .returns(true)

      url = @controller.sign_in_path_for(user)

      assert url.include? login_register_funnel_new_team_url
    end
  end

  describe "team redirection requested" do
    context "user is team member" do
      it "redirects to team" do
        url = @controller.sign_in_path_for(user, user_team)

        assert url.include? team_url(subdomain: user_team.subdomain)
      end
    end

    context "user is not team member" do
      it "does not redirect to team" do
        not_users_team = teams(:with_one_space)

        url = @controller.sign_in_path_for(user, not_users_team)

        refute url.include? team_url(subdomain: not_users_team.subdomain)
      end
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
