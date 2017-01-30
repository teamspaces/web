require 'test_helper'

describe SessionAuthentication, :controller do
  let(:user) { users(:lars) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }

  describe "#sign_in" do
    it "signs in user" do
      controller.sign_in(user)

      assert controller.user_signed_in?
    end
  end

  describe "#sign_out" do
    it "signs out user" do
      Authie::Session.expects(:sign_out)
                     .with(has_entry(user: user))

      controller.sign_out(user)
    end
  end

  describe "#authenticate_user!" do
    context "user is signed in" do
      it "does nothing" do
        controller.sign_in(user)
        controller.authenticate_user!

        assert_response :success
      end
    end

    context "user not signed in" do
      it "redirects to root_url" do
        controller.authenticate_user!

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    context "user is signed in on another subdomain" do
      it "signs in user" do
        AvailableUsersQuery.any_instance
                           .stubs(:user_signed_in_on_another_subdomain)
                           .returns(user)

        controller.expects(:sign_in).with(user)

        controller.authenticate_user!

        assert_response :success
      end
    end
  end
end
