require "test_helper"

describe Page::PathToRedirectToAfterDeletionInteractor, :model do
  subject { Page::PathToRedirectToAfterDeletionInteractor }

  describe "#call" do
    describe "page_to_redirect provided" do
      context "page_to_redirect is not page to delete" do
        it "redirects to edit page_to_redirect" do
          assert nil
        end
      end

      context "page_to_redirect is page to delete" do
        it "redirects to edit another page" do
          assert nil
        end
      end
    end

    context "several other pages exist in space" do
      it "redirects to next_page" do
        assert nil
      end
    end

    context "page_to_delete is last space page" do
      it "redirects to space_pages_path" do
        assert nil
      end
    end
  end
end


