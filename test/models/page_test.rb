require "test_helper"

describe Page do
  let(:space) { spaces(:furrow) }
  let(:marketing_page) { pages(:marketing) }

  should belong_to(:space)
  should validate_presence_of(:space)

  it "has one collab_page" do
      page = Page.create(space: space)
      assert_kind_of CollabPage, page.collab_page
  end

  describe "#destroy" do
    it "destroys collab_page as well" do
      marketing_page.collab_page

      assert_difference -> { CollabPage.count }, -1 do
        marketing_page.destroy
      end
    end
  end
end
