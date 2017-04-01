require "test_helper"

describe Page::NextPageQuery, :model do

  describe "#next_page" do
    context "space has several pages" do
      context "page has parent page" do
        it "returns parent page" do
          assert nil
        end
      end

      context "page has no parent page" do
        context "page has sibling before" do
          it "returns sibling before" do
            assert nil
          end
        end

        context "page has sibling after" do
          it "returns sibling after" do
            assert nil
          end
        end
      end
    end

    context "only page in space" do
      it "returns nil" do
        assert nil
      end
    end
  end
end
