require "test_helper"

describe PageContent do
  let(:page_content) { PageContent.new }

  it "must be valid" do
    value(page_content).must_be :valid?
  end
end
