require "test_helper"

describe PageRevisionAuthor do
  let(:page_revision_author) { PageRevisionAuthor.new }

  it "must be valid" do
    value(page_revision_author).must_be :valid?
  end
end
