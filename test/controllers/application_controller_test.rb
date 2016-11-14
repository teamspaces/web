require 'test_helper'

describe ApplicationController do

  context "not signed in" do
    it "redirects" do
        get teams_path
        assert_redirected_to new_user_session_path
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in_user

      get teams_path
      assert_response :success
    end
  end
end
