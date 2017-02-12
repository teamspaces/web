require 'test_helper'

describe PagesController do
  let(:team) { teams(:spaces) }
  let(:page) { pages(:spaces) }
  let(:space) { spaces(:spaces) }
  let(:space_without_pages) { spaces(:without_pages) }

  before(:each) { sign_in users(:ulf) }

  describe "#index" do
    it "redirects to first page" do
      get space_pages_url(space, subdomain: team.subdomain)
      assert_redirected_to page_path(space.pages.first, subdomain: team.subdomain)
    end

    context "without pages" do
      it "works" do
        get space_pages_url(space_without_pages, subdomain: team.subdomain)
        assert_response :success
      end
    end
  end

  describe "#show" do
    it "works" do
      get page_url(page, subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#edit" do
    it "works" do
      get edit_page_url(page, subdomain: team.subdomain)
      assert_response :success
    end
  end

  describe "#create" do
    it "works" do
      assert_difference "Page.count" do
        params = { page: { title: "Sunday Steak" } }
        post space_pages_url(space, subdomain: team.subdomain, params: params)
        assert_redirected_to edit_page_url(Page.last, subdomain: team.subdomain)
      end
    end
  end

  describe "#update" do
    it "works" do
      params = { page: { title: "Tender meat" } }
      patch page_url(page, subdomain: team.subdomain, params: params)
      assert_redirected_to page_url(page, subdomain: team.subdomain)

      assert_equal params[:page][:title], page.reload.title
    end
  end

  describe "#destroy" do
    it "works" do
      assert_difference "Page.count", -1 do
        delete page_url(page, subdomain: team.subdomain)
        assert_redirected_to space_pages_url(space, subdomain: team.subdomain)
      end
    end
  end
end
