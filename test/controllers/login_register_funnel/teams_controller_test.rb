require "test_helper"

describe LoginRegisterFunnel::TeamsController do
  let(:user) { users(:with_several_teams) }

  before(:each) do
    Team::Logo::AttachGeneratedLogo.stubs(:call).returns(true)
    Team::Logo::AttachUploadedLogo.stubs(:call).returns(true)
  end

  describe "#new" do
    context "user signed in" do
      it "responds successfully" do
        sign_in(user)
        get login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_response :success
      end
    end

    context "user not signed in" do
      it "redirects to root_url" do
        get login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  describe "#create" do
    before(:each) { sign_in(user) }
    let(:uploaded_logo_file) { "uploaded_logo_file" }

    describe "valid team attributes" do
      def post_valid_team_attributes
        valid_team_attributes = { create_team_for_user_form: { name: "bain ltd", subdomain: "baincompany", logo: uploaded_logo_file } }

        post login_register_funnel_create_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]), params: valid_team_attributes
      end

      it "creates team, with uploaded logo" do
        Team::Logo::AttachUploadedLogo.expects(:call)
                                      .with(has_entry(:file, uploaded_logo_file)
                                      .returns(true)

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

      it "does not create team" do
        assert_difference -> { Team.count }, 0 do
          post_invalid_team_attributes
        end
      end

      it "responds" do
        post_invalid_team_attributes

        assert_response :success
      end
    end
  end

  describe "#show" do
    let(:team_subdomain) { user.teams.first.subdomain }

    it "redirects to team spaces, user gets signed in on team subdomain" do
      sign_in(user)
      get show_team_subdomain_url(team_subomain: team_subdomain, subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert response.redirect_url.include?(spaces_url(subdomain: team_subdomain))
    end
  end

  describe "#index" do
    it "responds successfully" do
      sign_in(user)
      get login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])

      assert_response :success
    end
  end
end
