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
    it "signs out current user" do
      controller.sign_in(user)

      User::SignOut.expects(:call)
                   .with(all_of(has_entry(user: user),
                                has_key(:from_browser)))

      controller.sign_out
    end
  end

  describe "#sign_out_all_users_from_browser" do
    it "works" do
      User::SignOut.expects(:call)
                   .with(has_key(:from_browser))

      controller.sign_out_all_users_from_browser
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
        controller.expects(:redirect_unauthorized).returns(true)

        controller.authenticate_user!
      end
    end

    context "user is signed in on another subdomain" do
      describe "on team subdomain" do
        before(:each) do
          subdomain_team = teams(:power_rangers)
          controller.stubs(:current_team).returns(subdomain_team)
          controller.stubs(:subdomain_team).returns(subdomain_team)
        end

        it "signs in user" do
          AvailableUsersQuery.any_instance
                             .stubs(:user_signed_in_on_another_subdomain)
                             .returns(user)

          controller.expects(:sign_in).returns(true)

          controller.authenticate_user!
          assert_response :success
        end
      end
    end
  end
end
