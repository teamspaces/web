require "test_helper"

describe PageContentsController do
  let(:team) { teams(:furrow) }
  let(:page_content) { page_contents(:default) }

  before(:each) { sign_in_user }

  describe "#show" do
    it "responds successfully" do
      get page_content_url(page_content, subdomain: team.subdomain, format: :json)
      assert_response :success
    end
  end

  describe "#update" do
    it "updates contents" do
      new_contents = "Some pretty text in here.<br> Save me!"

      patch page_content_url(page_content, subdomain: team.subdomain, format: :json),
        params: { page_content: { contents: new_contents }}

      assert_response :success
      assert_equal new_contents, page_content.reload.contents
    end
  end
end
