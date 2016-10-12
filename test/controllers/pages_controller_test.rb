require 'test_helper'

describe PagesController do
  let(:page) { pages(:furrow) }

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
