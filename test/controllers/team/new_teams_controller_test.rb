require "test_helper"

describe Team::NewTeamsController do
  let(:user) { users(:lars) }
  before(:each) { sign_in user }
  before(:each) do
    ApplicationController.any_instance.stubs(:available_users)
  end

  describe "#index" do
    it "works" do
      get team_new_teams_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"])
      assert_response :success
    end
  end

  describe "#new" do
    it "works" do

    end
  end

  describe "#create" do
    it "works" do

    end
  end
end


