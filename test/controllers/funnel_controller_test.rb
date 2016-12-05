require "test_helper"

describe FunnelController do
  it "should get method" do
    get funnel_method_url
    value(response).must_be :success?
  end

  it "should get email" do
    get funnel_email_url
    value(response).must_be :success?
  end

  it "should get slack" do
    get funnel_slack_url
    value(response).must_be :success?
  end

  it "should get email_login" do
    get funnel_email_login_url
    value(response).must_be :success?
  end

  it "should get email_register" do
    get funnel_email_register_url
    value(response).must_be :success?
  end

end
