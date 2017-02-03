require "test_helper"

describe PageContent do
  let(:page) { pages(:spaces) }
  let(:page_content) { PageContent.new(page: page) }

  should belong_to(:page).dependent(:destroy)

  it "must be valid" do
    value(page_content).must_be :valid?
  end

  describe "#update_word_count" do
    it "updates Page#word_count" do
      page_content.contents = "Here is some hot and spicy text for you."
      page_content.save

      assert_equal 9, page.word_count
    end
  end
end
