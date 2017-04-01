require "test_helper"

describe Page::PathToRedirectToAfterDeletionInteractor, :controller do
  subject { Page::PathToRedirectToAfterDeletionInteractor }

  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:marketing_page) { pages(:marketing) }
  let(:onboarding_page) { pages(:onboarding) }

  describe "#call" do
    describe "page_to_redirect_to provided" do
      context "page_to_redirect_to is not page to delete" do
        it "redirects to edit page_to_redirect_to" do
          assert_equal controller.edit_page_path(marketing_page), subject.new(controller: controller,
                                                                              page_to_delete: onboarding_page,
                                                                              page_to_redirect: marketing_page).path

        end
      end

      context "page_to_redirect_to is page to delete" do
        it "redirects to edit another page" do
          assert true
        end
      end
    end

    context "several other pages exist in space" do
      it "redirects to next_page" do
        assert true
      end
    end

    context "page_to_delete is last space page" do
      it "redirects to space_pages_path" do
        assert true
      end
    end
  end
end
