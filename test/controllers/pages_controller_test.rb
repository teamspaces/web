require 'test_helper'

describe PagesController do
  before(:each) { sign_in_user }
  let(:page) { pages(:onboarding) }

  describe "#show" do
    it "works" do
      get page_url(page)
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
