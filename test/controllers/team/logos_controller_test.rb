require 'test_helper'

describe Team::LogosController do
  let(:user) { users(:with_one_space) }
  let(:team) { user.teams.first }

  before(:each) do
    Team::Logo::AttachGeneratedLogo.stubs(:call).returns(true)

    sign_in user
  end

  describe "#destroy" do
    it "generates a new team logo" do
      Team::Logo::AttachGeneratedLogo.expects(:call)
                                     .with(team: team)
                                     .returns(true)

      delete team_logo_url(subdomain: team.subdomain)
    end

    it "redirects to team path" do
      delete team_logo_url(subdomain: team.subdomain)

      assert_redirected_to team_path
    end
  end
end
