require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @controller = TeamsController.new
  end

  context "not signed in" do
    it "redirects" do
        get :index
        assert_redirected_to new_user_session_path
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in users(:lars)

      get :index
      assert_response :success
    end
  end
end
