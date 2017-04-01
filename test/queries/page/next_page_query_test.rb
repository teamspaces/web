require "test_helper"

describe Page::NextPageQuery, :model do
  subject { Page::NextPageQuery }

  let(:page_with_parent) { pages(:with_parent) }
  let(:parent_page) { pages(:spaces) }
  let(:first_page_in_space) { pages(:lowest_sort_order) }
  let(:second_page_in_space) { pages(:marketing) }
  let(:last_page_in_space) { pages(:spaces) }
  let(:penultimate_page_in_space) { pages(:onboarding) }
  let(:only_page_in_space) { pages(:private_slack_user_milad) }

  describe "#next_page" do
    context "space has several pages" do
      context "page has parent page" do
        it "returns parent page" do
          assert_equal parent_page, subject.new(page: page_with_parent).next_page
        end
      end

      context "page has no parent page" do
        context "page has sibling before" do
          it "returns sibling before" do
            assert_equal second_page_in_space, subject.new(page: first_page_in_space).next_page
          end
        end

        context "page has sibling after" do
          it "returns sibling after" do
            assert_equal penultimate_page_in_space, subject.new(page: last_page_in_space).next_page
          end
        end
      end
    end

    context "only page in space" do
      it "returns nil" do
        assert_nil subject.new(page: only_page_in_space).next_page
      end
    end
  end
end
