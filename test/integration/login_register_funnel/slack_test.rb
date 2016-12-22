require "test_helper"

describe "Slack", :integration do

  it "gets home" do
     visit '/landing'
     assert_link "Crseatsse Team with Slack"
  end
end
