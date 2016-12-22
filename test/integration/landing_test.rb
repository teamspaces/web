require "test_helper"

describe "Landing", :integration do

  it "has links for sign in, create team" do
     visit '/landing'

     assert_link "Sign In"
     assert_link "or create Team"
  end
end
