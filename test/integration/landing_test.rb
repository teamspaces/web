require "test_helper"

describe "Landing", :integration do

  it "gets home" do
     visit '/landing'

     click_link("or sign up with your email")

  end

end
