require "test_helper"

describe Space::PagesQuery, :model do
  let(:space) { spaces(:spaces) }
  let(:pages_hierachy_root_page) { pages(:lowest_sort_order) }
  let(:space_without_pages) { spaces(:without_pages) }

  describe "#root_page" do
    context "space has several pages" do
      it "returns hierachy root page with lowest sort oder" do
        assert_equal pages_hierachy_root_page, space.root_page
      end
    end

    context "space without pages" do
      it "returns nil" do
        assert_nil space_without_pages.root_page
      end
    end
  end

end
