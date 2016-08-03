require "test_helper"

describe RegisterController do
  it "should get index" do
    get register_url
    assert_response :success
  end
end
