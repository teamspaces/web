require 'test_helper'

describe PagesController do
  let(:team) { teams(:furrow) }
  let(:page) { pages(:onboarding) }

  before(:each) { sign_in_user }

  describe "#show" do
    it "works" do
      get page_url(page, subdomain: team.name)
      assert_response :success
    end
  end

  # TODO: Test all methods
  describe "all other methods" do
    it "need testing" do
      skip
    end
  end
end
