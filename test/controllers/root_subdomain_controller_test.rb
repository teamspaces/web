require "test_helper"

describe RootSubdomainController do
  describe "#index" do
    context "no space" do
      let(:user_without_space) { users(:without_space) }
      let(:team_without_space) { teams(:without_space) }

      it "redirects to new space" do
        sign_in(user_without_space)
        get root_subdomain_url(subdomain: team_without_space.subdomain)
        assert_redirected_to new_space_path
      end
    end

    context "with one space" do
      let(:user_with_one_space) { users(:with_one_space) }
      let(:team_with_one_space) { teams(:with_one_space) }

      it "redirects to the pages of that space" do
        sign_in(user_with_one_space)
        get root_subdomain_url(subdomain: team_with_one_space.subdomain)
        assert_redirected_to space_pages_path(team_with_one_space.spaces.first)
      end
    end

    context "with several spaces" do
      let(:user_with_two_spaces) { users(:with_two_spaces) }
      let(:team_with_two_spaces) { teams(:with_two_spaces) }

      it "redirects to choose space" do
        sign_in(user_with_two_spaces)
        get root_subdomain_url(subdomain: team_with_two_spaces.subdomain)
        assert_redirected_to spaces_path
      end
    end
  end
end
