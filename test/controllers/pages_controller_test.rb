require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  let(:page) { pages(:onboarding) }

  context "not signed in" do
    it "redirects" do

        get :show, params: { id: page.id }
        assert_redirected_to new_user_session_path
    end
  end

  context "signed in" do
    it "shows pages" do
      sign_in users(:lars)

      get :show, params: { id: page.id }
      assert_response :success
    end
  end
end
