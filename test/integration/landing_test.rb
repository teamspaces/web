require "test_helper"

describe "Landing", :integration do

  it "gets home" do
     visit '/landing'
     assert_link "Create Team with Slack"
  end
end
