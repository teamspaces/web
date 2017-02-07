require "test_helper"

describe Page do
  let(:space) { spaces(:spaces) }
  let(:marketing_page) { pages(:marketing) }

  should belong_to(:space)
  should validate_presence_of(:space)
  should have_one(:page_content).dependent(:destroy)

  before(:each) do
    Page.rebuild! # Needed to avoid advisory_lock issues with closure_tree
  end

  it "has one collab_page" do
      page = Page.create(space: space)
      assert_kind_of CollabPage, page.collab_page
  end

  it "has page_content" do
    page = Page.create(space: space)
    assert_kind_of PageContent, page.page_content
  end

  describe "#contents" do
    it "responds" do
      assert_respond_to marketing_page, :contents
    end
  end

  describe "#destroy" do
    it "destroys collab_page as well" do
      marketing_page.collab_page

      assert_difference -> { CollabPage.count }, -1 do
        marketing_page.destroy
      end
    end
  end

  describe "#after restore" do
    let(:page_with_parent) { pages(:with_parent) }
    let(:parent_page) { page_with_parent.parent}

    it "restores parents and rebuilds tree" do
      page_with_parent.destroy
      parent_page.destroy

      parent_page.expects(:restore).with(recursive: true)
      parent_page.expects(:rebuild!)

      page_with_parent.restore(recursive: true)
    end
  end
end
