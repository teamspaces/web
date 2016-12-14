require "test_helper"

describe PageContent do
  let(:page) { pages(:spaces) }
  let(:page_content) { PageContent.new(page: page) }

  it "must be valid" do
    value(page_content).must_be :valid?
  end
end
