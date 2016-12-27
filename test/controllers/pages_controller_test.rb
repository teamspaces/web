require 'test_helper'

describe PagesController do
  let(:team) { teams(:spaces) }
  let(:page) { pages(:onboarding) }

  before(:each) { sign_in users(:ulf) }

  describe "#show" do
    it "works" do
      get page_url(page, subdomain: team.subdomain)
      assert_response :success
    end
  end

  # TODO: Test all methods
  describe "all other methods" do
    it "need testing" do
      # skip
    end
  end
end
