require "test_helper"

describe Page::PathToRedirectToAfterDeletionInteractor, :controller do
  subject { Page::PathToRedirectToAfterDeletionInteractor }

  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:marketing_page) { pages(:marketing) }
  let(:onboarding_page) { pages(:onboarding) }
  let(:only_page_in_space) { pages(:only_page_in_space) }

  describe "#call" do
    context "page_to_redirect_to provided" do
      context "page_to_redirect_to is not page to delete" do
        it "redirects to edit page_to_redirect_to" do
          assert_equal controller.edit_page_path(marketing_page), subject.call(controller: controller,
                                                                               page_to_delete: onboarding_page,
                                                                               page_to_redirect: marketing_page).path

        end
      end

      context "page_to_redirect_to is page to delete" do
        it "redirects to edit another page" do
          redirect_path = subject.call(controller: controller,
                                       page_to_delete: marketing_page,
                                       page_to_redirect: marketing_page).path

          assert_not_equal controller.edit_page_path(marketing_page), redirect_path
        end
      end
    end

    context "no page_to_redirect_to provided" do
      context "several other pages exist in space" do
        it "redirects to next_page" do
          subject.any_instance.expects(:next_page).returns(onboarding_page)

          assert_equal controller.edit_page_path(onboarding_page), subject.call(controller: controller,
                                                                                page_to_delete: marketing_page).path
        end
      end

      context "page_to_delete is only page in space" do
        it "redirects to space_pages_path" do
          assert_equal controller.space_pages_path(only_page_in_space.space), subject.call(controller: controller,
                                                                                           page_to_delete: only_page_in_space).path
        end
      end
    end
  end
end
