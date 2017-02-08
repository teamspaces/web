require "test_helper"

describe PageDecorator, :model do

  describe "#title_with_fallback" do
    context "space with title" do
      let(:page_with_title) { pages(:marketing) }

      it "returns page title" do
        assert_equal page_with_title.title, page_with_title.decorate.title_with_fallback
      end
    end

    context "page without title" do
      let(:page_without_title) { Page.new(title: nil) }

      it "returns a fallback title" do
        refute page_without_title.decorate.title_with_fallback.blank?
      end
    end
  end
end
